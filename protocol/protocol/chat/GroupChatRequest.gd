const PROTOCOL_ID = 4002
const PROTOCOL_CLASS_NAME = "GroupChatRequest"


var message: String

func _to_string() -> String:
	const jsonTemplate = "{message:'{}'}"
	var params = [self.message]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeString(packet.message)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.message = result0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
