class_name _LogoutRequest

const ByteBuffer = preload("../ByteBuffer.gd")




func protocolId() -> int:
	return 1002

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class LogoutRequestRegistration:
	func write(buffer: ByteBuffer, packet: _LogoutRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer) -> _LogoutRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _LogoutRequest = buffer.newInstance(1002)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet