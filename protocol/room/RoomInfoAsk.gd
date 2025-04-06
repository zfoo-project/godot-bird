class_name _RoomInfoAsk

const ByteBuffer = preload("../ByteBuffer.gd")


var roomId: int

func protocolId() -> int:
	return 6014

func _to_string() -> String:
	const jsonTemplate = "{roomId:{}}"
	var params = [self.roomId]
	return jsonTemplate.format(params, "{}")

class RoomInfoAskRegistration:
	func write(buffer: ByteBuffer, packet: _RoomInfoAsk):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.roomId)
		pass

	func read(buffer: ByteBuffer) -> _RoomInfoAsk:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _RoomInfoAsk = buffer.newInstance(6014)
		var result0 = buffer.readLong()
		packet.roomId = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet