const PROTOCOL_ID = 4004
const PROTOCOL_CLASS_NAME = "GroupHistoryMessageResponse"
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessages: Array[ChatMessage]

func _to_string() -> String:
	const jsonTemplate = "{chatMessages:{}}"
	var params = [JSON.stringify(self.chatMessages)]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writePacketArray(packet.chatMessages, 4000)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var list0 = buffer.readPacketArray(4000)
	packet.chatMessages = list0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
