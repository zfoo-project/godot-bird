class_name _RankInfo

const ByteBuffer = preload("../ByteBuffer.gd")
const PlayerInfo = preload("./PlayerInfo.gd")


var playerInfo: PlayerInfo
var time: int
var score: int

func protocolId() -> int:
	return 402

func _to_string() -> String:
	const jsonTemplate = "{playerInfo:{}, time:{}, score:{}}"
	var params = [self.playerInfo, self.time, self.score]
	return jsonTemplate.format(params, "{}")

class RankInfoRegistration:
	func write(buffer: ByteBuffer, packet: _RankInfo):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacket(packet.playerInfo, 400)
		buffer.writeInt(packet.score)
		buffer.writeLong(packet.time)
		pass

	func read(buffer: ByteBuffer) -> _RankInfo:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _RankInfo = buffer.newInstance(402)
		var result0 = buffer.readPacket(400)
		packet.playerInfo = result0
		var result1 = buffer.readInt()
		packet.score = result1
		var result2 = buffer.readLong()
		packet.time = result2
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet