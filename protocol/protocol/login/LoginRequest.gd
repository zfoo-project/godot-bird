const PROTOCOL_ID = 1000
const PROTOCOL_CLASS_NAME = "LoginRequest"


var account: String
var password: String

func map() -> Dictionary:
	var map = {}
	map["account"] = account
	map["password"] = password
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.account)
	buffer.writeString(packet.password)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.account = result0
	var result1 = buffer.readString()
	packet.password = result1
	return packet
