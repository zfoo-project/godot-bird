class_name _GroupHistoryMessageRequest

const ByteBuffer = preload("../ByteBuffer.gd")


var lastMessageId: int

func protocolId() -> int:
	return 4003

func _to_string() -> String:
	const jsonTemplate = "{lastMessageId:{}}"
	var params = [self.lastMessageId]
	return jsonTemplate.format(params, "{}")

class GroupHistoryMessageRequestRegistration:
	func write(buffer: ByteBuffer, packet: _GroupHistoryMessageRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.lastMessageId)
		pass

	func read(buffer: ByteBuffer) -> _GroupHistoryMessageRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GroupHistoryMessageRequest = buffer.newInstance(4003)
		var result0 = buffer.readLong()
		packet.lastMessageId = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet