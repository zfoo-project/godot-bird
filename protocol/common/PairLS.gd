const PROTOCOL_ID = 113


var key: int
var value: String

func get_class() -> String:
	return "PairLS"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.key)
	buffer.writeString(packet.value)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.key = result0
	var result1 = buffer.readString()
	packet.value = result1
	return packet
