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

package fun.jiucai.bogers.entity;

import com.zfoo.orm.anno.EntityCache;
import com.zfoo.orm.anno.GraalvmNativeEntityCache;
import com.zfoo.orm.anno.Id;
import com.zfoo.orm.anno.Version;
import com.zfoo.orm.model.IEntity;
import fun.jiucai.bogers.protocol.common.PlayerInfo;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author jaysunxiao
 * @version 1.0
 * @since 2021-01-20 13:55
 */
@EntityCache
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PlayerEntity implements IEntity<Long> {

    private transient long sid;

    @Id
    private long id;
    @Version
    private long vs;

    private String name;
    private String avatar;
    private int level;
    private long exp;

    private long lastLoginTime;
    private long registerTime;
    private long lastLogoutTime;
    // 货币钱包，直接new出来给个默认值，可以防止空指针异常
    private CurrencyPo currencyPo = new CurrencyPo();

    private String message;

    private long joinedRoomId;
    public static PlayerEntity valueOf(long id, String name, int level, long lastLoginTime, long registerTime) {
        var entity = new PlayerEntity();
        entity.id = id;
        entity.name = name;
        entity.level = level;
        entity.lastLoginTime = lastLoginTime;
        entity.registerTime = registerTime;
        return entity;
    }

    public PlayerInfo toPlayerInfo() {
        return PlayerInfo.valueOf(id, name, avatar, level, exp);
    }

    public void addExp(int addExp) {
        this.exp += addExp;
    }

    @Override
    public Long id() {
        return id;
    }


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getVs() {
        return vs;
    }

    public void setVs(long vs) {
        this.vs = vs;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public long getExp() {
        return exp;
    }

    public void setExp(long exp) {
        this.exp = exp;
    }

    public long getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(long lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public long getRegisterTime() {
        return registerTime;
    }

    public void setRegisterTime(long registerTime) {
        this.registerTime = registerTime;
    }

    public CurrencyPo getCurrencyPo() {
        return currencyPo;
    }

    public void setCurrencyPo(CurrencyPo currencyPo) {
        this.currencyPo = currencyPo;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public long getLastLogoutTime() {
        return lastLogoutTime;
    }

    public void setLastLogoutTime(long lastLogoutTime) {
        this.lastLogoutTime = lastLogoutTime;
    }

    public long getJoinedRoomId() {
        return joinedRoomId;
    }

    public void setJoinedRoomId(long joinedRoomId) {
        this.joinedRoomId = joinedRoomId;
    }
}
