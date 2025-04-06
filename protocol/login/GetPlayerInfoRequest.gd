class_name _GetPlayerInfoRequest

const ByteBuffer = preload("../ByteBuffer.gd")


var token: String

func protocolId() -> int:
	return 1004

func _to_string() -> String:
	const jsonTemplate = "{token:'{}'}"
	var params = [self.token]
	return jsonTemplate.format(params, "{}")

class GetPlayerInfoRequestRegistration:
	func write(buffer: ByteBuffer, packet: _GetPlayerInfoRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.token)
		pass

	func read(buffer: ByteBuffer) -> _GetPlayerInfoRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GetPlayerInfoRequest = buffer.newInstance(1004)
		var result0 = buffer.readString()
		packet.token = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet