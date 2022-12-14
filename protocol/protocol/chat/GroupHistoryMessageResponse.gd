const PROTOCOL_ID = 4004
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessages: Array[ChatMessage]

func get_class() -> String:
	return "GroupHistoryMessageResponse"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacketArray(packet.chatMessages, 4000)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var list0 = buffer.readPacketArray(4000)
	packet.chatMessages = list0
	return packet
