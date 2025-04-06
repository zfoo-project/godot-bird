class_name _JoinRoomRequest

const ByteBuffer = preload("../ByteBuffer.gd")


var roomId: int

func protocolId() -> int:
	return 6011

func _to_string() -> String:
	const jsonTemplate = "{roomId:{}}"
	var params = [self.roomId]
	return jsonTemplate.format(params, "{}")

class JoinRoomRequestRegistration:
	func write(buffer: ByteBuffer, packet: _JoinRoomRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.roomId)
		pass

	func read(buffer: ByteBuffer) -> _JoinRoomRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _JoinRoomRequest = buffer.newInstance(6011)
		var result0 = buffer.readLong()
		packet.roomId = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet