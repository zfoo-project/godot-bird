/*
 *  Copyright (C) 2020 The zfoo Authors
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License. You may obtain a copy of the License at
 *  http://www.apache.org/licenses/LICENSE-2.0
 *  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 *  on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and limitations under the License.
 */

package fun.jiucai.bogers.controller;

import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import com.zfoo.event.manager.EventBus;
import com.zfoo.event.model.AppStartEvent;
import com.zfoo.net.NetContext;
import com.zfoo.net.anno.PacketReceiver;
import com.zfoo.net.session.Session;
import com.zfoo.orm.OrmContext;
import com.zfoo.orm.anno.EntityCacheAutowired;
import com.zfoo.orm.cache.IEntityCache;
import com.zfoo.orm.util.MongoIdUtils;
import com.zfoo.protocol.collection.CollectionUtils;
import com.zfoo.scheduler.util.SingleCache;
import com.zfoo.scheduler.util.TimeUtils;
import com.zfoo.storage.anno.StorageAutowired;
import com.zfoo.storage.model.IStorage;
import fun.jiucai.bogers.entity.PlayerEntity;
import fun.jiucai.bogers.entity.ScoreRankEntity;
import fun.jiucai.bogers.event.PlayerLevelUpEvent;
import fun.jiucai.bogers.protocol.notice.CurrencyUpdateNotice;
import fun.jiucai.bogers.protocol.notice.PlayerExpNotice;
import fun.jiucai.bogers.protocol.battle.BattleResultRequest;
import fun.jiucai.bogers.protocol.battle.BattleResultResponse;
import fun.jiucai.bogers.protocol.cache.ScoreRankRequest;
import fun.jiucai.bogers.protocol.cache.ScoreRankResponse;
import fun.jiucai.bogers.protocol.common.PlayerInfo;
import fun.jiucai.bogers.protocol.common.RankInfo;
import fun.jiucai.bogers.resource.PlayerExpResource;
import fun.jiucai.bogers.util.SendUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author jaysunxiao
 */
@Component
@Slf4j
public class BattleController implements ApplicationListener<AppStartEvent> {

    @EntityCacheAutowired
    private IEntityCache<Long, PlayerEntity> playerEntityCaches;

    @StorageAutowired
    private IStorage<Integer, PlayerExpResource> playerExpStorage;

    private static final int RANK_SIZE = 200;

    private volatile int rankLimit = 0;
    private volatile int minScore = 0;

    private SingleCache<List<RankInfo>> rankCache;


    @Override
    public void onApplicationEvent(AppStartEvent appStartEvent) {
        rankCache = SingleCache.build(10 * TimeUtils.MILLIS_PER_SECOND, () -> {
            var rankList = new ArrayList<ScoreRankEntity>();
            OrmContext.getOrmManager()
                    .getCollection(ScoreRankEntity.class)
                    .find()
                    .sort(Sorts.descending("score"))
                    .limit(RANK_SIZE)
                    .forEach(it -> rankList.add(it));

            var playerInfoMap = new HashMap<Long, PlayerInfo>();
            OrmContext.getOrmManager()
                    .getCollection(PlayerEntity.class)
                    .find(Filters.in("_id", rankList.stream().map(it -> it.getPlayerId()).collect(Collectors.toList())))
                    .forEach(it -> playerInfoMap.put(it.getId(), it.toPlayerInfo()));

            var list = new ArrayList<RankInfo>();
            for (var rankEntity : rankList) {
                list.add(RankInfo.valueOf(playerInfoMap.get(rankEntity.getPlayerId()), rankEntity.getTime(), rankEntity.getScore()));
            }

            if (CollectionUtils.isNotEmpty(list)) {
                minScore = list.get(list.size() - 1).getScore();
            }
            rankLimit = list.size();
            return list;
        });
    }

    @PacketReceiver
    public void atScoreRankRequest(Session session, ScoreRankRequest request) {
        var uid = session.getUid();
        var sid = session.getSid();
        log.info("c[{}][{}]排行榜信息查询", uid, sid);
        NetContext.getRouter().send(session, ScoreRankResponse.valueOf(rankCache.get()));
    }

    @PacketReceiver
    public void atBattleResultRequest(Session session, BattleResultRequest request) {
        var uid = session.getUid();
        var sid = session.getSid();

        var player = playerEntityCaches.load(uid);

        var score = request.getScore();

        // 注意线程号和异步请求回调的线程号是一致的
        log.info("c[{}][{}]玩家战斗结果[score:{}]", uid, sid, score);

        battleScore(player, score);

        // 战斗过后如果上了排行榜，则奖励一下，每一分值一个金币，半个钻石
        var currencyPo = player.getCurrencyPo();
        currencyPo.setGold(currencyPo.getGold() + score);
        currencyPo.setGem(currencyPo.getGem() + score / 2);
        addPlayerExp(player, score);

        playerEntityCaches.update(player);

        NetContext.getRouter().send(session, BattleResultResponse.valueOf(score));
        NetContext.getRouter().send(session, CurrencyUpdateNotice.valueOf(currencyPo.toCurrencyVO()));
    }


    public boolean battleScore(PlayerEntity playerEntity, int score) {
        var playerId = playerEntity.getId();

        // 如果没有上榜，直接返回；上榜，则将当前成绩插入数据库
        if (score <= minScore && rankLimit >= RANK_SIZE) {
            return false;
        }

        // 获取一个分布式自增唯一id
        var id = MongoIdUtils.getIncrementIdFromMongoDefault(ScoreRankEntity.class);
        // 插入数据库
        OrmContext.getAccessor().insert(ScoreRankEntity.valueOf(id, playerId, TimeUtils.now(), score));
        return true;
    }

    public void addPlayerExp(PlayerEntity playerEntity, int playerExp) {

        playerEntity.addExp(playerExp);

        for (int i = 0; i < playerExpStorage.size(); i++) {
            var level = playerEntity.getLevel();
            var exp = playerEntity.getExp();

            if (!playerExpStorage.contain(level + 1)) {
                break;
            }

            var playerExpConfig = playerExpStorage.get(level);
            if (exp < playerExpConfig.getExp()) {
                break;
            }
            playerEntity.setLevel(playerEntity.getLevel() + 1);
            playerEntity.setExp(exp - playerExpConfig.getExp());

            // 抛出一个升级的事件
            EventBus.post(PlayerLevelUpEvent.valueOf(playerEntity, level));
        }
        SendUtils.sendToPlayer(playerEntity, PlayerExpNotice.valueOf(playerEntity.getLevel(), playerEntity.getExp()));

    }

}
