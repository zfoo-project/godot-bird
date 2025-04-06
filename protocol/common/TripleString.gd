class_name _TripleString

const ByteBuffer = preload("../ByteBuffer.gd")


var left: String
var middle: String
var right: String

func protocolId() -> int:
	return 115

func _to_string() -> String:
	const jsonTemplate = "{left:'{}', middle:'{}', right:'{}'}"
	var params = [self.left, self.middle, self.right]
	return jsonTemplate.format(params, "{}")

class TripleStringRegistration:
	func write(buffer: ByteBuffer, packet: _TripleString):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.left)
		buffer.writeString(packet.middle)
		buffer.writeString(packet.right)
		pass

	func read(buffer: ByteBuffer) -> _TripleString:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _TripleString = buffer.newInstance(115)
		var result0 = buffer.readString()
		packet.left = result0
		var result1 = buffer.readString()
		packet.middle = result1
		var result2 = buffer.readString()
		packet.right = result2
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet