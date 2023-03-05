const PROTOCOL_ID = 4004
const PROTOCOL_CLASS_NAME = "GroupHistoryMessageResponse"
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessages: Array[ChatMessage]

func map() -> Dictionary:
	var map = {}
	map["chatMessages"] = chatMessages
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
