class_name _GroupHistoryMessageResponse

const ByteBuffer = preload("../ByteBuffer.gd")
const ChatMessage = preload("./ChatMessage.gd")


var chatMessages: Array[ChatMessage]

func protocolId() -> int:
	return 4004

func _to_string() -> String:
	const jsonTemplate = "{chatMessages:{}}"
	var params = [JSON.stringify(self.chatMessages)]
	return jsonTemplate.format(params, "{}")

class GroupHistoryMessageResponseRegistration:
	func write(buffer: ByteBuffer, packet: _GroupHistoryMessageResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacketArray(packet.chatMessages, 4000)
		pass

	func read(buffer: ByteBuffer) -> _GroupHistoryMessageResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GroupHistoryMessageResponse = buffer.newInstance(4004)
		var list0 = buffer.readPacketArray(4000)
		packet.chatMessages = list0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet