const PROTOCOL_ID = 1300
const PROTOCOL_CLASS_NAME = "TestRequest"


var message: String

func map() -> Dictionary:
	var map = {}
	map["message"] = message
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.message)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.message = result0
	return packet
