class_name _PairString

const ByteBuffer = preload("../ByteBuffer.gd")


var key: String
var value: String

func protocolId() -> int:
	return 112

func _to_string() -> String:
	const jsonTemplate = "{key:'{}', value:'{}'}"
	var params = [self.key, self.value]
	return jsonTemplate.format(params, "{}")

class PairStringRegistration:
	func write(buffer: ByteBuffer, packet: _PairString):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.key)
		buffer.writeString(packet.value)
		pass

	func read(buffer: ByteBuffer) -> _PairString:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _PairString = buffer.newInstance(112)
		var result0 = buffer.readString()
		packet.key = result0
		var result1 = buffer.readString()
		packet.value = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet