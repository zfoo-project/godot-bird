const PROTOCOL_ID = 24
const PROTOCOL_CLASS_NAME = "GatewaySynchronizeSidAsk"


var gatewayHostAndPort: String
var sidMap: Dictionary

func map() -> Dictionary:
	var map = {}
	map["gatewayHostAndPort"] = gatewayHostAndPort
	map["sidMap"] = sidMap
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.gatewayHostAndPort)
	buffer.writeLongLongMap(packet.sidMap)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.gatewayHostAndPort = result0
	var map1 = buffer.readLongLongMap()
	packet.sidMap = map1
	return packet
