const PROTOCOL_ID = 3000
const PROTOCOL_CLASS_NAME = "BattleScoreAsk"


var playerId: int
var score: int

func map() -> Dictionary:
	var map = {}
	map["playerId"] = playerId
	map["score"] = score
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeLong(packet.playerId)
	buffer.writeInt(packet.score)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.playerId = result0
	var result1 = buffer.readInt()
	packet.score = result1
	return packet
