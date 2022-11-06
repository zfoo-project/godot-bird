const PROTOCOL_ID = 116


var left: int
var middle: String
var right: String

func get_class() -> String:
	return "TripleLSS"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.left)
	buffer.writeString(packet.middle)
	buffer.writeString(packet.right)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.left = result0
	var result1 = buffer.readString()
	packet.middle = result1
	var result2 = buffer.readString()
	packet.right = result2
	return packet
