const PROTOCOL_ID = 3000


var playerId: int
var score: int

func get_class() -> String:
	return "BattleScoreAsk"

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
