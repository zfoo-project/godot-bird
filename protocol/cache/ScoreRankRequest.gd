class_name _ScoreRankRequest

const ByteBuffer = preload("../ByteBuffer.gd")




func protocolId() -> int:
	return 3002

func _to_string() -> String:
	const jsonTemplate = "{}"
	var params = []
	return jsonTemplate.format(params, "{}")

class ScoreRankRequestRegistration:
	func write(buffer: ByteBuffer, packet: _ScoreRankRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		pass

	func read(buffer: ByteBuffer) -> _ScoreRankRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _ScoreRankRequest = buffer.newInstance(3002)
		
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet