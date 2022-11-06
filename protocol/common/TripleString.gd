const PROTOCOL_ID = 115


var left: String
var middle: String
var right: String

func get_class() -> String:
	return "TripleString"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.left)
	buffer.writeString(packet.middle)
	buffer.writeString(packet.right)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.left = result0
	var result1 = buffer.readString()
	packet.middle = result1
	var result2 = buffer.readString()
	packet.right = result2
	return packet
