const PROTOCOL_ID = 1101


var level: int
var exp: int

func toString() -> String:
	return "PlayerExpNotice"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.exp)
	buffer.writeInt(packet.level)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.exp = result0
	var result1 = buffer.readInt()
	packet.level = result1
	return packet
