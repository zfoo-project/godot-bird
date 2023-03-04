const PROTOCOL_ID = 1000


var account: String
var password: String

func toString() -> String:
	return "LoginRequest"

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
