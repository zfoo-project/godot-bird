const PROTOCOL_ID = 2


var host: String
var port: int

func toString() -> String:
	return "UdpAttachment"

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
