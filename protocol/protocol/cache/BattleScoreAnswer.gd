const PROTOCOL_ID = 3001


var rankReward: bool

func get_class() -> String:
	return "BattleScoreAnswer"

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
