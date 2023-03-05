const PROTOCOL_ID = 3003
const PROTOCOL_CLASS_NAME = "ScoreRankResponse"
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")
const RankInfo = preload("res://protocol/protocol/common/RankInfo.gd")


var ranks: Array[RankInfo]

func map() -> Dictionary:
	var map = {}
	map["ranks"] = ranks
	return map

func _to_string() -> String:
	return JSON.stringify(map())

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
