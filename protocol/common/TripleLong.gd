const PROTOCOL_ID = 114
const PROTOCOL_CLASS_NAME = "TripleLong"


var left: int
var middle: int
var right: int

func map() -> Dictionary:
	var map = {}
	map["left"] = left
	map["middle"] = middle
	map["right"] = right
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
