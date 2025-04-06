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

package fun.jiucai.bogers;

import com.zfoo.event.model.AppStartEvent;
import com.zfoo.net.core.HostAndPort;
import com.zfoo.net.core.tcp.TcpServer;
import com.zfoo.net.util.NetUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.mongo.MongoDataAutoConfiguration;
import org.springframework.boot.autoconfigure.data.mongo.MongoRepositoriesAutoConfiguration;
import org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration;

/**
 * @author jaysunxiao
 * @version 1.0
 * @since 2021-01-20 16:00
 */
@SpringBootApplication(
        scanBasePackages = "fun.jiucai.bogers",
        exclude = {
                // 排除MongoDB自动配置
                MongoDataAutoConfiguration.class,
                MongoRepositoriesAutoConfiguration.class,
                MongoAutoConfiguration.class
        })
public class Application {
    /**
     * tcp服务器的默认端口
     */
    public static final int TCP_SERVER_PORT = 16000;

    /**
     * websocket服务器的默认端口
     */
    public static final int WEBSOCKET_SERVER_PORT = 18000;

    public static void main(String[] args) {
        var context = SpringApplication.run(Application.class, args);


        context.registerShutdownHook();
        context.publishEvent(new AppStartEvent(context));

        // tcp服务器，可以同时启动tcp服务器和websocket服务器
        var tcpServer = new TcpServer(HostAndPort.valueOf(NetUtils.getLocalhostStr(), TCP_SERVER_PORT));
        tcpServer.start();

        // websocket服务器
//        var websocketServer = new WebsocketServer(HostAndPort.valueOf(NetUtils.getLocalhostStr(), WEBSOCKET_SERVER_PORT));
//        websocketServer.start();
    }

}
