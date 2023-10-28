const PROTOCOL_ID = 1000
const PROTOCOL_CLASS_NAME = "LoginRequest"


var account: String
var password: String

func _to_string() -> String:
	const jsonTemplate = "{account:'{}', password:'{}'}"
	var params = [self.account, self.password]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeString(packet.account)
	buffer.writeString(packet.password)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.account = result0
	var result1 = buffer.readString()
	packet.password = result1
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
