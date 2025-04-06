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

package fun.jiucai.bogers.resource;

import com.zfoo.net.packet.common.Error;
import com.zfoo.storage.anno.Id;
import com.zfoo.storage.anno.Storage;
import lombok.Getter;

/**
 * @author jaysunxiao
 * @version 1.0
 * @since 2021-01-20 16:20
 */
@Storage
@Getter
public class I18n {

    @Id
    private String id;

    private String cn;

    public static enum Ids {

        fail,
        ok,
        // 请求成功，但是不会在客户端上显示提示
        ok_quietly,

        parameter_error,
        parameter_env_error,

        internal_server_error,

        // 未知错误，请联系客服，我们会尽快解决
        error_unknown,

        // 配置错误
        error_config,
        // 未知错误（1），请联系客服，我们会尽快解决
        error_1,
        error_2,
        error_3,
        error_4,
        error_5,
        error_6,
        error_7,

        account_not_exist,
        account_cannot_have_sensitive_word,

        // 请先登录,
        login_first,
        login_already,
        login_exist,
        login_account_cannot_be_empty,
        login_password_cannot_be_empty,
        login_account_format_error,
        login_password_format_error,
        login_token_expire,

        room_max_num_limit,
        // 重复加入房间
        room_join_repeatedly,
        // 只有房主有权限
        room_owner_limit,
        // 房间服务器不存在
        room_server_limit,
        // 房间服务器资源不够
        room_no_resource,
        // 正在创建房间请稍等
        room_creating,
        // 玩家不在房间
        room_no_player,
        // 房间人数不在合理的范围内
        room_player_range_limit,

        ;

        public Error error() {
            var error = new Error();
            error.setCode(this.ordinal());
            error.setMessage(this.name());
            return error;
        }


    }

}
