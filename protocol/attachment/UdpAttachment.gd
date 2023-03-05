const PROTOCOL_ID = 2
const PROTOCOL_CLASS_NAME = "UdpAttachment"


var host: String
var port: int

func map() -> Dictionary:
	var map = {}
	map["host"] = host
	map["port"] = port
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.host)
	buffer.writeInt(packet.port)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.host = result0
	var result1 = buffer.readInt()
	packet.port = result1
	return packet
