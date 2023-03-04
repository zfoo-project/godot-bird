const PROTOCOL_ID = 24


var gatewayHostAndPort: String
var sidMap: Dictionary

func toString() -> String:
	return "GatewaySynchronizeSidAsk"

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
