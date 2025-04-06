class_name _Heartbeat

const ByteBuffer = preload("../ByteBuffer.gd")




func protocolId() -> int:
	return 102

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class HeartbeatRegistration:
	func write(buffer: ByteBuffer, packet: _Heartbeat):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer) -> _Heartbeat:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _Heartbeat = buffer.newInstance(102)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet