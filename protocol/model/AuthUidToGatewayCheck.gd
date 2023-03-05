const PROTOCOL_ID = 20
const PROTOCOL_CLASS_NAME = "AuthUidToGatewayCheck"


var uid: int

func map() -> Dictionary:
	var map = {}
	map["uid"] = uid
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.uid)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.uid = result0
	return packet
