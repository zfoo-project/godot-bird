class_name _UdpAttachment

const ByteBuffer = preload("../ByteBuffer.gd")


var host: String
var port: int

func protocolId() -> int:
	return 3

func _to_string() -> String:
	const jsonTemplate = "{host:'{}', port:{}}"
	var params = [self.host, self.port]
	return jsonTemplate.format(params, "{}")

class UdpAttachmentRegistration:
	func write(buffer: ByteBuffer, packet: _UdpAttachment):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.host)
		buffer.writeInt(packet.port)
		pass

	func read(buffer: ByteBuffer) -> _UdpAttachment:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _UdpAttachment = buffer.newInstance(3)
		var result0 = buffer.readString()
		packet.host = result0
		var result1 = buffer.readInt()
		packet.port = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet