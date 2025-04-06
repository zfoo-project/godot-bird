package fun.jiucai.bogers.protocol.room;


public class RoomInfoAsk {

    private long roomId;

    public RoomInfoAsk() {
    }

    public RoomInfoAsk(long roomId) {
        this.roomId = roomId;
    }

    public long getRoomId() {
        return roomId;
    }

    public void setRoomId(long roomId) {
        this.roomId = roomId;
    }
}
