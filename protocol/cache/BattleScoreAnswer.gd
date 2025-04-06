class_name _BattleScoreAnswer

const ByteBuffer = preload("../ByteBuffer.gd")


var rankReward: bool

func protocolId() -> int:
	return 3001

func _to_string() -> String:
	const jsonTemplate = "{rankReward:{}}"
	var params = [self.rankReward]
	return jsonTemplate.format(params, "{}")

class BattleScoreAnswerRegistration:
	func write(buffer: ByteBuffer, packet: _BattleScoreAnswer):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeBool(packet.rankReward)
		pass

	func read(buffer: ByteBuffer) -> _BattleScoreAnswer:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _BattleScoreAnswer = buffer.newInstance(3001)
		var result0 = buffer.readBool() 
		packet.rankReward = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet