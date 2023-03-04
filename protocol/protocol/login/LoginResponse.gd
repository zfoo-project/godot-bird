const PROTOCOL_ID = 1001


var token: String

func toString() -> String:
	return "LoginResponse"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.token)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.token = result0
	return packet
