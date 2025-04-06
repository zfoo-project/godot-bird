/*
 * Copyright (C) 2020 The zfoo Authors
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the License.
 */

package fun.jiucai.bogers.robot;

import com.zfoo.net.NetContext;
import com.zfoo.net.core.HostAndPort;
import com.zfoo.net.core.tcp.TcpClient;
import com.zfoo.net.util.NetUtils;
import com.zfoo.protocol.util.JsonUtils;
import com.zfoo.protocol.util.RandomUtils;
import com.zfoo.protocol.util.ThreadUtils;
import com.zfoo.scheduler.util.TimeUtils;

import fun.jiucai.bogers.Application;
import fun.jiucai.bogers.protocol.battle.BattleResultRequest;
import fun.jiucai.bogers.protocol.cache.ScoreRankRequest;
import fun.jiucai.bogers.protocol.cache.ScoreRankResponse;
import fun.jiucai.bogers.protocol.login.LoginRequest;
import org.junit.Ignore;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.function.Consumer;

/**
 * @author jaysunxiao
 */
@Ignore
public class RobotTest {

    private static final Logger logger = LoggerFactory.getLogger(RobotTest.class);



    @Test
    public void tankClient() throws Exception {
        var context = new ClassPathXmlApplicationContext("robot-application.xml");

        var myTankClient = new TcpClient(HostAndPort.valueOf(NetUtils.getLocalhostStr(), Application.TCP_SERVER_PORT));
        var myTankSession = myTankClient.start();

        // 模拟客户端，发送一个登录请求
        var loginRequest = new LoginRequest("tank1", "tank1");
        NetContext.getRouter().send(myTankSession, loginRequest);
        ThreadUtils.sleep(2 * TimeUtils.MILLIS_PER_SECOND);

        // 发送一个战斗结果请求
        var battleResultRequest = BattleResultRequest.valueOf(RandomUtils.randomInt());
        NetContext.getRouter().send(myTankSession, battleResultRequest);
        ThreadUtils.sleep(TimeUtils.MILLIS_PER_SECOND);

        // 发送一个获取分数排行榜的信息
        var scoreRankRequest = ScoreRankRequest.valueOf();
        NetContext.getRouter().send(myTankSession, scoreRankRequest);
        ThreadUtils.sleep(TimeUtils.MILLIS_PER_SECOND);

        var scoreRankSyncResponse = NetContext.getRouter().syncAsk(myTankSession, scoreRankRequest, ScoreRankResponse.class, null).packet();
        logger.info("sync 排行榜 [{}]", JsonUtils.object2String(scoreRankSyncResponse));
        ThreadUtils.sleep(TimeUtils.MILLIS_PER_SECOND);

        NetContext.getRouter().asyncAsk(myTankSession, scoreRankRequest, ScoreRankResponse.class, null)
                .whenComplete(new Consumer<ScoreRankResponse>() {
                    @Override
                    public void accept(ScoreRankResponse scoreRankResponse) {
                        logger.info("async 排行榜 [{}]", JsonUtils.object2String(scoreRankResponse));
                    }
                });
        ThreadUtils.sleep(TimeUtils.MILLIS_PER_SECOND);
    }

}
