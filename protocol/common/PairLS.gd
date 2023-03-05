const PROTOCOL_ID = 113
const PROTOCOL_CLASS_NAME = "PairLS"


var key: int
var value: String

func map() -> Dictionary:
	var map = {}
	map["key"] = key
	map["value"] = value
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
