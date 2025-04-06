class_name _Error

const ByteBuffer = preload("../ByteBuffer.gd")


var code: int
var message: String

func protocolId() -> int:
	return 101

func _to_string() -> String:
	const jsonTemplate = "{code:{}, message:'{}'}"
	var params = [self.code, self.message]
	return jsonTemplate.format(params, "{}")

class ErrorRegistration:
	func write(buffer: ByteBuffer, packet: _Error):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.code)
		buffer.writeString(packet.message)
		pass

	func read(buffer: ByteBuffer) -> _Error:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _Error = buffer.newInstance(101)
		var result0 = buffer.readInt()
		packet.code = result0
		var result1 = buffer.readString()
		packet.message = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet