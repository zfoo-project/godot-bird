

var left: int
var middle: int
var right: int

const PROTOCOL_ID = 114

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.left)
	buffer.writeLong(packet.middle)
	buffer.writeLong(packet.right)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.left = result0
	var result1 = buffer.readLong()
	packet.middle = result1
	var result2 = buffer.readLong()
	packet.right = result2
	return packet
