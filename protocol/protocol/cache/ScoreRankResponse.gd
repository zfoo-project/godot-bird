const PROTOCOL_ID = 3003
const PROTOCOL_CLASS_NAME = "ScoreRankResponse"
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")
const RankInfo = preload("res://protocol/protocol/common/RankInfo.gd")


var ranks: Array[RankInfo]

func _to_string() -> String:
	const jsonTemplate = "{ranks:{}}"
	var params = [JSON.stringify(self.ranks)]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writePacketArray(packet.ranks, 402)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var list0 = buffer.readPacketArray(402)
	packet.ranks = list0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
