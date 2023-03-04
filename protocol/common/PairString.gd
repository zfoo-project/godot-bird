const PROTOCOL_ID = 112


var key: String
var value: String

func toString() -> String:
	return "PairString"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.key)
	buffer.writeString(packet.value)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.key = result0
	var result1 = buffer.readString()
	packet.value = result1
	return packet
