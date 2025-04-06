class_name _TripleLSS

const ByteBuffer = preload("../ByteBuffer.gd")


var left: int
var middle: String
var right: String

func protocolId() -> int:
	return 116

func _to_string() -> String:
	const jsonTemplate = "{left:{}, middle:'{}', right:'{}'}"
	var params = [self.left, self.middle, self.right]
	return jsonTemplate.format(params, "{}")

class TripleLSSRegistration:
	func write(buffer: ByteBuffer, packet: _TripleLSS):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.left)
		buffer.writeString(packet.middle)
		buffer.writeString(packet.right)
		pass

	func read(buffer: ByteBuffer) -> _TripleLSS:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _TripleLSS = buffer.newInstance(116)
		var result0 = buffer.readLong()
		packet.left = result0
		var result1 = buffer.readString()
		packet.middle = result1
		var result2 = buffer.readString()
		packet.right = result2
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet