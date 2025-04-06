class_name _GroupChatRequest

const ByteBuffer = preload("../ByteBuffer.gd")


var message: String

func protocolId() -> int:
	return 4002

func _to_string() -> String:
	const jsonTemplate = "{message:'{}'}"
	var params = [self.message]
	return jsonTemplate.format(params, "{}")

class GroupChatRequestRegistration:
	func write(buffer: ByteBuffer, packet: _GroupChatRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.message)
		pass

	func read(buffer: ByteBuffer) -> _GroupChatRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GroupChatRequest = buffer.newInstance(4002)
		var result0 = buffer.readString()
		packet.message = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet