const PROTOCOL_ID = 4001
const PROTOCOL_CLASS_NAME = "GroupChatMessageNotice"
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessage: ChatMessage

func map() -> Dictionary:
	var map = {}
	map["chatMessage"] = chatMessage
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
