class_name _BattleResultRequest

const ByteBuffer = preload("../ByteBuffer.gd")


var score: int

func protocolId() -> int:
	return 1006

func _to_string() -> String:
	const jsonTemplate = "{score:{}}"
	var params = [self.score]
	return jsonTemplate.format(params, "{}")

class BattleResultRequestRegistration:
	func write(buffer: ByteBuffer, packet: _BattleResultRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.score)
		pass

	func read(buffer: ByteBuffer) -> _BattleResultRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _BattleResultRequest = buffer.newInstance(1006)
		var result0 = buffer.readInt()
		packet.score = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet