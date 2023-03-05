const PROTOCOL_ID = 103
const PROTOCOL_CLASS_NAME = "ObjectB"


var flag: bool

func map() -> Dictionary:
	var map = {}
	map["flag"] = flag
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeBool(packet.flag)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readBool() 
	packet.flag = result0
	return packet
