const PROTOCOL_ID = 4001
const PROTOCOL_CLASS_NAME = "GroupChatMessageNotice"
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessage: ChatMessage

func _to_string() -> String:
	const jsonTemplate = "{chatMessage:{}}"
	var params = [self.chatMessage]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writePacket(packet.chatMessage, 4000)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(4000)
	packet.chatMessage = result0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
