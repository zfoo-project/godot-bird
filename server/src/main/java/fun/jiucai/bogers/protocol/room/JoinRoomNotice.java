package fun.jiucai.bogers.protocol.room;

import com.zfoo.protocol.anno.Note;
import fun.jiucai.bogers.protocol.common.PlayerInfo;

import java.util.List;
@Note("新玩家加入房间会通知其它所有玩家")
public record JoinRoomNotice (
    Room room,
    @Note("匹配到的玩家基本数据")
    List<PlayerInfo> matchPlayerInfos
) {
}