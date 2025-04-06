class_name _PlayerExpNotice

const ByteBuffer = preload("../ByteBuffer.gd")


var level: int
var exp: int

func protocolId() -> int:
	return 1101

func _to_string() -> String:
	const jsonTemplate = "{level:{}, exp:{}}"
	var params = [self.level, self.exp]
	return jsonTemplate.format(params, "{}")

class PlayerExpNoticeRegistration:
	func write(buffer: ByteBuffer, packet: _PlayerExpNotice):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.exp)
		buffer.writeInt(packet.level)
		pass

	func read(buffer: ByteBuffer) -> _PlayerExpNotice:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _PlayerExpNotice = buffer.newInstance(1101)
		var result0 = buffer.readLong()
		packet.exp = result0
		var result1 = buffer.readInt()
		packet.level = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet