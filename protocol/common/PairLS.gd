class_name _PairLS

const ByteBuffer = preload("../ByteBuffer.gd")


var key: int
var value: String

func protocolId() -> int:
	return 113

func _to_string() -> String:
	const jsonTemplate = "{key:{}, value:'{}'}"
	var params = [self.key, self.value]
	return jsonTemplate.format(params, "{}")

class PairLSRegistration:
	func write(buffer: ByteBuffer, packet: _PairLS):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.key)
		buffer.writeString(packet.value)
		pass

	func read(buffer: ByteBuffer) -> _PairLS:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _PairLS = buffer.newInstance(113)
		var result0 = buffer.readLong()
		packet.key = result0
		var result1 = buffer.readString()
		packet.value = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet