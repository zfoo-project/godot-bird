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

package fun.jiucai.bogers.protocol.common;

import com.zfoo.protocol.anno.Protocol;

/**
 * @author jaysunxiao
 */
@Protocol(id = 402)
public class RankInfo {

    private PlayerInfo playerInfo;

    private long time;

    private int score;

    public static RankInfo valueOf(PlayerInfo playerInfo, long time, int score) {
        var packet = new RankInfo();
        packet.playerInfo = playerInfo;
        packet.time = time;
        packet.score = score;
        return packet;
    }

    public PlayerInfo getPlayerInfo() {
        return playerInfo;
    }

    public void setPlayerInfo(PlayerInfo playerInfo) {
        this.playerInfo = playerInfo;
    }

    public long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }
}
