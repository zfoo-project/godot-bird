const PROTOCOL_ID = 3003
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")
const RankInfo = preload("res://protocol/protocol/common/RankInfo.gd")


var ranks: Array[RankInfo]

func toString() -> String:
	return "ScoreRankResponse"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacketArray(packet.ranks, 402)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var list0 = buffer.readPacketArray(402)
	packet.ranks = list0
	return packet
