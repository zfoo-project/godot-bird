package fun.jiucai.bogers.protocol.room;

import com.zfoo.protocol.anno.Note;

@Note("自己主动退出游戏就等于退出房间")
public record ExitRoomRequest (
    @Note("房间id")
    long roomId
) {
}