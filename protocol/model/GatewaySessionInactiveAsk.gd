const PROTOCOL_ID = 23
const PROTOCOL_CLASS_NAME = "GatewaySessionInactiveAsk"


var gatewayHostAndPort: String
var sid: int
var uid: int

func map() -> Dictionary:
	var map = {}
	map["gatewayHostAndPort"] = gatewayHostAndPort
	map["sid"] = sid
	map["uid"] = uid
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.gatewayHostAndPort)
	buffer.writeLong(packet.sid)
	buffer.writeLong(packet.uid)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.gatewayHostAndPort = result0
	var result1 = buffer.readLong()
	packet.sid = result1
	var result2 = buffer.readLong()
	packet.uid = result2
	return packet
