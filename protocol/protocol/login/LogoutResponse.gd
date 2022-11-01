

var uid: int
var sid: int

const PROTOCOL_ID = 1003

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.sid)
	buffer.writeLong(packet.uid)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.sid = result0
	var result1 = buffer.readLong()
	packet.uid = result1
	return packet
