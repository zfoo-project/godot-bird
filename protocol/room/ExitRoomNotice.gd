class_name _ExitRoomNotice

const ByteBuffer = preload("../ByteBuffer.gd")
const PlayerInfo = preload("../common/PlayerInfo.gd")
const Room = preload("./Room.gd")


var room: Room
# 匹配到的玩家基本数据
var matchPlayerInfos: Array[PlayerInfo]

func protocolId() -> int:
	return 6007

func _to_string() -> String:
	const jsonTemplate = "{room:{}, matchPlayerInfos:{}}"
	var params = [self.room, JSON.stringify(self.matchPlayerInfos)]
	return jsonTemplate.format(params, "{}")

class ExitRoomNoticeRegistration:
	func write(buffer: ByteBuffer, packet: _ExitRoomNotice):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacketArray(packet.matchPlayerInfos, 400)
		buffer.writePacket(packet.room, 6013)
		pass

	func read(buffer: ByteBuffer) -> _ExitRoomNotice:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _ExitRoomNotice = buffer.newInstance(6007)
		var list0 = buffer.readPacketArray(400)
		packet.matchPlayerInfos = list0
		var result1 = buffer.readPacket(6013)
		packet.room = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet
