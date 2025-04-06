class_name _KickPlayerNotice

const ByteBuffer = preload("../ByteBuffer.gd")


var sid: int
var uid: int

func protocolId() -> int:
	return 1010

func _to_string() -> String:
	const jsonTemplate = "{sid:{}, uid:{}}"
	var params = [self.sid, self.uid]
	return jsonTemplate.format(params, "{}")

class KickPlayerNoticeRegistration:
	func write(buffer: ByteBuffer, packet: _KickPlayerNotice):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.sid)
		buffer.writeLong(packet.uid)
		pass

	func read(buffer: ByteBuffer) -> _KickPlayerNotice:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _KickPlayerNotice = buffer.newInstance(1010)
		var result0 = buffer.readLong()
		packet.sid = result0
		var result1 = buffer.readLong()
		packet.uid = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet