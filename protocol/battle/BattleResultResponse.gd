class_name _BattleResultResponse

const ByteBuffer = preload("../ByteBuffer.gd")


var score: int

func protocolId() -> int:
	return 1007

func _to_string() -> String:
	const jsonTemplate = "{score:{}}"
	var params = [self.score]
	return jsonTemplate.format(params, "{}")

class BattleResultResponseRegistration:
	func write(buffer: ByteBuffer, packet: _BattleResultResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.score)
		pass

	func read(buffer: ByteBuffer) -> _BattleResultResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _BattleResultResponse = buffer.newInstance(1007)
		var result0 = buffer.readInt()
		packet.score = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet