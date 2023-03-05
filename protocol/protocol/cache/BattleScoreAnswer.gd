const PROTOCOL_ID = 3001
const PROTOCOL_CLASS_NAME = "BattleScoreAnswer"


var rankReward: bool

func map() -> Dictionary:
	var map = {}
	map["rankReward"] = rankReward
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeBool(packet.rankReward)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readBool() 
	packet.rankReward = result0
	return packet
