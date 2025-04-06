class_name _Message

const ByteBuffer = preload("../ByteBuffer.gd")


var code: int
var message: String

func protocolId() -> int:
	return 100

func _to_string() -> String:
	const jsonTemplate = "{code:{}, message:'{}'}"
	var params = [self.code, self.message]
	return jsonTemplate.format(params, "{}")

class MessageRegistration:
	func write(buffer: ByteBuffer, packet: _Message):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.code)
		buffer.writeString(packet.message)
		pass

	func read(buffer: ByteBuffer) -> _Message:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _Message = buffer.newInstance(100)
		var result0 = buffer.readInt()
		packet.code = result0
		var result1 = buffer.readString()
		packet.message = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet