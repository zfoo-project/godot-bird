const PROTOCOL_ID = 4001
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessage: ChatMessage

func get_class() -> String:
	return "GroupChatMessageNotice"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacket(packet.chatMessage, 4000)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(4000)
	packet.chatMessage = result0
	return packet
