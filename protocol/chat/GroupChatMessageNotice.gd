class_name _GroupChatMessageNotice

const ByteBuffer = preload("../ByteBuffer.gd")
const ChatMessage = preload("./ChatMessage.gd")


var chatMessage: ChatMessage

func protocolId() -> int:
	return 4001

func _to_string() -> String:
	const jsonTemplate = "{chatMessage:{}}"
	var params = [self.chatMessage]
	return jsonTemplate.format(params, "{}")

class GroupChatMessageNoticeRegistration:
	func write(buffer: ByteBuffer, packet: _GroupChatMessageNotice):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacket(packet.chatMessage, 4000)
		pass

	func read(buffer: ByteBuffer) -> _GroupChatMessageNotice:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GroupChatMessageNotice = buffer.newInstance(4001)
		var result0 = buffer.readPacket(4000)
		packet.chatMessage = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet