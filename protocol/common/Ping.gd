class_name _Ping

const ByteBuffer = preload("../ByteBuffer.gd")




func protocolId() -> int:
	return 103

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class PingRegistration:
	func write(buffer: ByteBuffer, packet: _Ping):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer) -> _Ping:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _Ping = buffer.newInstance(103)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet