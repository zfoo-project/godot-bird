class_name _HttpAttachment

const ByteBuffer = preload("../ByteBuffer.gd")


var uid: int
var taskExecutorHash: int

func protocolId() -> int:
	return 4

func _to_string() -> String:
	const jsonTemplate = "{uid:{}, taskExecutorHash:{}}"
	var params = [self.uid, self.taskExecutorHash]
	return jsonTemplate.format(params, "{}")

class HttpAttachmentRegistration:
	func write(buffer: ByteBuffer, packet: _HttpAttachment):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.taskExecutorHash)
		buffer.writeLong(packet.uid)
		pass

	func read(buffer: ByteBuffer) -> _HttpAttachment:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _HttpAttachment = buffer.newInstance(4)
		var result0 = buffer.readInt()
		packet.taskExecutorHash = result0
		var result1 = buffer.readLong()
		packet.uid = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet