class_name _ExitRoomResponse

const ByteBuffer = preload("../ByteBuffer.gd")




func protocolId() -> int:
	return 6009

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class ExitRoomResponseRegistration:
	func write(buffer: ByteBuffer, packet: _ExitRoomResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer) -> _ExitRoomResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _ExitRoomResponse = buffer.newInstance(6009)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet