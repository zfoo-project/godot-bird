class_name _BattleScoreAsk

const ByteBuffer = preload("../ByteBuffer.gd")


var playerId: int
var score: int

func protocolId() -> int:
	return 3000

func _to_string() -> String:
	const jsonTemplate = "{playerId:{}, score:{}}"
	var params = [self.playerId, self.score]
	return jsonTemplate.format(params, "{}")

class BattleScoreAskRegistration:
	func write(buffer: ByteBuffer, packet: _BattleScoreAsk):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.playerId)
		buffer.writeInt(packet.score)
		pass

	func read(buffer: ByteBuffer) -> _BattleScoreAsk:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _BattleScoreAsk = buffer.newInstance(3000)
		var result0 = buffer.readLong()
		packet.playerId = result0
		var result1 = buffer.readInt()
		packet.score = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet