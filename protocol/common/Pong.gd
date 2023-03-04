const PROTOCOL_ID = 104


var time: int

func toString() -> String:
	return "Pong"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.time)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.time = result0
	return packet
