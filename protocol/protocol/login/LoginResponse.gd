const PROTOCOL_ID = 1001
const PROTOCOL_CLASS_NAME = "LoginResponse"


var token: String

func map() -> Dictionary:
	var map = {}
	map["token"] = token
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.token)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.token = result0
	return packet
