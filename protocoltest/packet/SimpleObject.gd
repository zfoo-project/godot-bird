const PROTOCOL_ID = 104
const PROTOCOL_CLASS_NAME = "SimpleObject"


var c: int
var g: bool

func map() -> Dictionary:
	var map = {}
	map["c"] = c
	map["g"] = g
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.c)
	buffer.writeBool(packet.g)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.c = result0
	var result1 = buffer.readBool() 
	packet.g = result1
	return packet
