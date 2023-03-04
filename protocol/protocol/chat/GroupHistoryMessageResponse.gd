const PROTOCOL_ID = 4004
const ChatMessage = preload("res://protocol/protocol/chat/ChatMessage.gd")


var chatMessages: Array[ChatMessage]

func toString() -> String:
	return "GroupHistoryMessageResponse"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacketArray(packet.chatMessages, 4000)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = []
	var size2 = buffer.readInt()
	if (size2 > 0):
		for index1 in range(size2):
			var result3 = buffer.readPacket(4000)
			result0.append(result3)
	packet.chatMessages = result0
	return packet
