const PROTOCOL_ID = 1101
const PROTOCOL_CLASS_NAME = "PlayerExpNotice"


var level: int
var exp: int

func map() -> Dictionary:
	var map = {}
	map["level"] = level
	map["exp"] = exp
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
