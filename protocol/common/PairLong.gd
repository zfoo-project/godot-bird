const PROTOCOL_ID = 111


var key: int
var value: int

func get_class() -> String:
	return "PairLong"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.key)
	buffer.writeLong(packet.value)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.key = result0
	var result1 = buffer.readLong()
	packet.value = result1
	return packet
