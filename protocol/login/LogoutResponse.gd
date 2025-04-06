class_name _LogoutResponse

const ByteBuffer = preload("../ByteBuffer.gd")




func protocolId() -> int:
	return 1003

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class LogoutResponseRegistration:
	func write(buffer: ByteBuffer, packet: _LogoutResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer) -> _LogoutResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _LogoutResponse = buffer.newInstance(1003)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet