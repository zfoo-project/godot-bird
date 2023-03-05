const PROTOCOL_ID = 4003
const PROTOCOL_CLASS_NAME = "GroupHistoryMessageRequest"


var lastMessageId: int

func map() -> Dictionary:
	var map = {}
	map["lastMessageId"] = lastMessageId
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.lastMessageId)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.lastMessageId = result0
	return packet
