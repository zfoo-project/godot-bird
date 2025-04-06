class_name _ExitRoomRequest

const ByteBuffer = preload("../ByteBuffer.gd")

# 自己主动退出游戏就等于退出房间
# 房间id
var roomId: int

func protocolId() -> int:
	return 6008

func _to_string() -> String:
	const jsonTemplate = "{roomId:{}}"
	var params = [self.roomId]
	return jsonTemplate.format(params, "{}")

class ExitRoomRequestRegistration:
	func write(buffer: ByteBuffer, packet: _ExitRoomRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.roomId)
		pass

	func read(buffer: ByteBuffer) -> _ExitRoomRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _ExitRoomRequest = buffer.newInstance(6008)
		var result0 = buffer.readLong()
		packet.roomId = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet