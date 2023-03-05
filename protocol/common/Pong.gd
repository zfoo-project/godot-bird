const PROTOCOL_ID = 104
const PROTOCOL_CLASS_NAME = "Pong"


var time: int

func map() -> Dictionary:
	var map = {}
	map["time"] = time
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
