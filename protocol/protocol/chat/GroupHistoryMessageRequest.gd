const PROTOCOL_ID = 4003
const PROTOCOL_CLASS_NAME = "GroupHistoryMessageRequest"


var lastMessageId: int

func _to_string() -> String:
	const jsonTemplate = "{lastMessageId:{}}"
	var params = [self.lastMessageId]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeLong(packet.lastMessageId)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.lastMessageId = result0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
