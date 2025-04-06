package fun.jiucai.bogers.protocol.room;

import com.zfoo.protocol.anno.Note;
import fun.jiucai.bogers.protocol.common.PlayerInfo;

import java.util.List;
public record ExitRoomNotice (
    Room room,
    @Note("匹配到的玩家基本数据")
    List<PlayerInfo> matchPlayerInfos
) {
}