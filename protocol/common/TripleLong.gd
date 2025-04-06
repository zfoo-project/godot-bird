class_name _TripleLong

const ByteBuffer = preload("../ByteBuffer.gd")


var left: int
var middle: int
var right: int

func protocolId() -> int:
	return 114

func _to_string() -> String:
	const jsonTemplate = "{left:{}, middle:{}, right:{}}"
	var params = [self.left, self.middle, self.right]
	return jsonTemplate.format(params, "{}")

class TripleLongRegistration:
	func write(buffer: ByteBuffer, packet: _TripleLong):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.left)
		buffer.writeLong(packet.middle)
		buffer.writeLong(packet.right)
		pass

	func read(buffer: ByteBuffer) -> _TripleLong:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _TripleLong = buffer.newInstance(114)
		var result0 = buffer.readLong()
		packet.left = result0
		var result1 = buffer.readLong()
		packet.middle = result1
		var result2 = buffer.readLong()
		packet.right = result2
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet