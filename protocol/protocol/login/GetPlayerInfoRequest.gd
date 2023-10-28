const PROTOCOL_ID = 1004
const PROTOCOL_CLASS_NAME = "GetPlayerInfoRequest"


var token: String

func _to_string() -> String:
	const jsonTemplate = "{token:'{}'}"
	var params = [self.token]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeString(packet.token)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.token = result0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
