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

package fun.jiucai.bogers.util;

import com.zfoo.net.util.security.AesUtils;
import com.zfoo.protocol.model.Triple;
import com.zfoo.protocol.util.RandomUtils;
import com.zfoo.protocol.util.StringUtils;
import com.zfoo.scheduler.util.TimeUtils;

/**
 * @author jaysunxiao
 * @version 1.0
 * @since 2019-12-25 16:19
 */
public abstract class TokenUtils {

    /**
     * token的有效期为半年
     */
    private static final long TOKEN_EXPIRE_TIME = 180 * TimeUtils.MILLIS_PER_DAY;

    /**
     * 加密方式：用户id，加盐，过期时间戳
     */
    public static String encrypt(long userId) {
        var salt = RandomUtils.randomString(8);
        var now = TimeUtils.now() + TOKEN_EXPIRE_TIME;
        var source = userId + StringUtils.VERTICAL_BAR + salt + StringUtils.VERTICAL_BAR + now;
        return AesUtils.getEncryptString(source);
    }


    public static Triple<Long, String, Long> decrypt(String token) {
        var source = AesUtils.getDecryptString(token);
        var splits = source.split(StringUtils.VERTICAL_BAR_REGEX);
        var userId = Long.parseLong(splits[0]);
        var salt = splits[1];
        var expireTime = Long.parseLong(splits[2]);
        return new Triple<>(userId, salt, expireTime);
    }

}
