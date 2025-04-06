class_name _PairIntLong

const ByteBuffer = preload("../ByteBuffer.gd")


var key: int
var value: int

func protocolId() -> int:
	return 110

func _to_string() -> String:
	const jsonTemplate = "{key:{}, value:{}}"
	var params = [self.key, self.value]
	return jsonTemplate.format(params, "{}")

class PairIntLongRegistration:
	func write(buffer: ByteBuffer, packet: _PairIntLong):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.key)
		buffer.writeLong(packet.value)
		pass

	func read(buffer: ByteBuffer) -> _PairIntLong:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _PairIntLong = buffer.newInstance(110)
		var result0 = buffer.readInt()
		packet.key = result0
		var result1 = buffer.readLong()
		packet.value = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet