class_name _LoginRequest

const ByteBuffer = preload("../ByteBuffer.gd")


var account: String
var password: String

func protocolId() -> int:
	return 1000

func _to_string() -> String:
	const jsonTemplate = "{account:'{}', password:'{}'}"
	var params = [self.account, self.password]
	return jsonTemplate.format(params, "{}")

class LoginRequestRegistration:
	func write(buffer: ByteBuffer, packet: _LoginRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.account)
		buffer.writeString(packet.password)
		pass

	func read(buffer: ByteBuffer) -> _LoginRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _LoginRequest = buffer.newInstance(1000)
		var result0 = buffer.readString()
		packet.account = result0
		var result1 = buffer.readString()
		packet.password = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet