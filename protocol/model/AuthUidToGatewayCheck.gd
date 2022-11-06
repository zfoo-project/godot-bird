const PROTOCOL_ID = 20


var uid: int

func get_class() -> String:
	return "AuthUidToGatewayCheck"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.uid)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.uid = result0
	return packet
