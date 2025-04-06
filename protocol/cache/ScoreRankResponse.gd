class_name _ScoreRankResponse

const ByteBuffer = preload("../ByteBuffer.gd")
const PlayerInfo = preload("../common/PlayerInfo.gd")
const RankInfo = preload("../common/RankInfo.gd")


var ranks: Array[RankInfo]

func protocolId() -> int:
	return 3003

func _to_string() -> String:
	const jsonTemplate = "{ranks:{}}"
	var params = [JSON.stringify(self.ranks)]
	return jsonTemplate.format(params, "{}")

class ScoreRankResponseRegistration:
	func write(buffer: ByteBuffer, packet: _ScoreRankResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacketArray(packet.ranks, 402)
		pass

	func read(buffer: ByteBuffer) -> _ScoreRankResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _ScoreRankResponse = buffer.newInstance(3003)
		var list0 = buffer.readPacketArray(402)
		packet.ranks = list0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet