const PROTOCOL_ID = 1006
const PROTOCOL_CLASS_NAME = "BattleResultRequest"


var score: int

func map() -> Dictionary:
	var map = {}
	map["score"] = score
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.score)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.score = result0
	return packet
