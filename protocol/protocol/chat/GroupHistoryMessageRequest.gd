const PROTOCOL_ID = 4003


var lastMessageId: int

func get_class() -> String:
	return "GroupHistoryMessageRequest"

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
