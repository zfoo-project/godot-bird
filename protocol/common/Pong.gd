class_name _Pong

const ByteBuffer = preload("../ByteBuffer.gd")


var time: int

func protocolId() -> int:
	return 104

func _to_string() -> String:
	const jsonTemplate = "{time:{}}"
	var params = [self.time]
	return jsonTemplate.format(params, "{}")

class PongRegistration:
	func write(buffer: ByteBuffer, packet: _Pong):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.time)
		pass

	func read(buffer: ByteBuffer) -> _Pong:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _Pong = buffer.newInstance(104)
		var result0 = buffer.readLong()
		packet.time = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet