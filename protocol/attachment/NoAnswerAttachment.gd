class_name _NoAnswerAttachment

const ByteBuffer = preload("../ByteBuffer.gd")


var taskExecutorHash: int

func protocolId() -> int:
	return 5

func _to_string() -> String:
	const jsonTemplate = "{taskExecutorHash:{}}"
	var params = [self.taskExecutorHash]
	return jsonTemplate.format(params, "{}")

class NoAnswerAttachmentRegistration:
	func write(buffer: ByteBuffer, packet: _NoAnswerAttachment):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.taskExecutorHash)
		pass

	func read(buffer: ByteBuffer) -> _NoAnswerAttachment:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _NoAnswerAttachment = buffer.newInstance(5)
		var result0 = buffer.readInt()
		packet.taskExecutorHash = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet