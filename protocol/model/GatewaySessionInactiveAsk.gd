const PROTOCOL_ID = 23


var gatewayHostAndPort: String
var sid: int
var uid: int

func get_class() -> String:
	return "GatewaySessionInactiveAsk"

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
