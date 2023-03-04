const PROTOCOL_ID = 1301


var message: String

func toString() -> String:
	return "TestResponse"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.message)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.message = result0
	return packet
