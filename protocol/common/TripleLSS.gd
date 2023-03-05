const PROTOCOL_ID = 116
const PROTOCOL_CLASS_NAME = "TripleLSS"


var left: int
var middle: String
var right: String

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
	buffer.writeString(packet.middle)
	buffer.writeString(packet.right)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.left = result0
	var result1 = buffer.readString()
	packet.middle = result1
	var result2 = buffer.readString()
	packet.right = result2
	return packet
