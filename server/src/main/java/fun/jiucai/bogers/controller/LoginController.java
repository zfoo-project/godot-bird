/*
 * Copyright (C) 2020 The zfoo Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

package fun.jiucai.bogers.controller;

import com.zfoo.net.NetContext;
import com.zfoo.net.anno.PacketReceiver;
import com.zfoo.net.anno.Task;
import com.zfoo.net.packet.common.Ping;
import com.zfoo.net.packet.common.Pong;
import com.zfoo.net.router.attachment.SignalAttachment;
import com.zfoo.net.session.Session;
import com.zfoo.orm.OrmContext;
import com.zfoo.orm.anno.EntityCacheAutowired;
import com.zfoo.orm.cache.IEntityCache;
import com.zfoo.orm.util.MongoIdUtils;
import com.zfoo.protocol.util.StringUtils;
import com.zfoo.scheduler.util.TimeUtils;
import fun.jiucai.bogers.entity.AccountEntity;
import fun.jiucai.bogers.entity.PlayerEntity;
import fun.jiucai.bogers.protocol.login.*;
import fun.jiucai.bogers.resource.I18n;
import fun.jiucai.bogers.service.SystemService;
import fun.jiucai.bogers.util.TokenUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author godotg
 * @version 1.0
 * @since 2021-01-20 14:43
 */
@Component
@Slf4j
public class LoginController {

    @EntityCacheAutowired
    private IEntityCache<Long, PlayerEntity> playerEntityCaches;

    @Autowired
    private SystemService systemService;

    @PacketReceiver
    public void atLogoutRequest(Session session, LogoutRequest request) {
        var uid = session.getUid();
        var sid = session.getSid();

        log.info("atLogoutRequest [{}][{}] 玩家退出游戏", uid, sid);

        var player = playerEntityCaches.load(uid);
        player.setSid(0);
    }

    // 将玩家登录处理放入异步线程，避免了主线程阻塞，提高了系统的并发处理能力，使得服务器可以同时处理多个玩家的登录请求。不使用EventBus.asyncExecute依然可以运行
    @PacketReceiver(Task.EventBus)
    public void atLoginRequest(Session session, LoginRequest request, SignalAttachment attachment) {
        var account = StringUtils.trim(request.getAccount());
        var password = request.getPassword();

        if (StringUtils.isBlank(account)) {
            NetContext.getRouter().send(session, I18n.Ids.account_not_exist.error());
            return;
        }

        if (systemService.hasSensitiveWord(account)) {
            NetContext.getRouter().send(session, I18n.Ids.account_cannot_have_sensitive_word.error());
            return;
        }

        var sid = session.getSid();

        var accountEntity = OrmContext.getAccessor().load(account, AccountEntity.class);
        if (accountEntity == null) {
            var id = MongoIdUtils.getIncrementIdFromMongoDefault(PlayerEntity.class);

            OrmContext.getAccessor().insert(PlayerEntity.valueOf(id, account, 1, TimeUtils.now(), TimeUtils.now()));
            accountEntity = AccountEntity.valueOf(account, account, password, id);
            OrmContext.getAccessor().insert(accountEntity);

            playerEntityCaches.invalidate(id);
        }

        var uid = accountEntity.getUid();
        log.info("atLoginRequest [{}][{}] 玩家登录v[account:{}]", uid, sid, account);

        var player = playerEntityCaches.load(uid);
        player.setLastLoginTime(TimeUtils.now());

        // 设置session
        player.setSid(session.getSid());
        session.setUid(uid);

        if (player.id() <= 0) {
            NetContext.getRouter().send(session, I18n.Ids.account_not_exist.error());
            return;
        }

        var token = TokenUtils.encrypt(uid);
        NetContext.getRouter().send(session, new LoginResponse(token), attachment);
    }

    @PacketReceiver
    public void atGetPlayerInfoRequest(Session session, GetPlayerInfoRequest request) {
        var sid = session.getSid();

        var token = request.getToken();
        var triple = TokenUtils.decrypt(token);

        var uid = triple.getLeft();
        var expireTime = triple.getRight();

        if (TimeUtils.now() > expireTime) {
            NetContext.getRouter().send(session, I18n.Ids.login_token_expire.error());
            return;
        }

        log.info("atGetPlayerInfoRequest [{}][{}] 玩家信息请求", uid, sid);

        var player = playerEntityCaches.load(uid);

        player.setSid(session.getSid());
        session.setUid(uid);

        NetContext.getRouter().send(session, new GetPlayerInfoResponse(player.toPlayerInfo(), player.getCurrencyPo().toCurrencyVO()));
    }

    @PacketReceiver(Task.NettyIO)
    public void atPing(Session session, Ping request) {
        NetContext.getRouter().send(session, Pong.valueOf(TimeUtils.now()));
    }

}
