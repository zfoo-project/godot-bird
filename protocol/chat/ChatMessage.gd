class_name _ChatMessage

const ByteBuffer = preload("../ByteBuffer.gd")


var id: int
var sendId: int
var avatar: String
var name: String
var message: String
var timestamp: int

func protocolId() -> int:
	return 4000

func _to_string() -> String:
	const jsonTemplate = "{id:{}, sendId:{}, avatar:'{}', name:'{}', message:'{}', timestamp:{}}"
	var params = [self.id, self.sendId, self.avatar, self.name, self.message, self.timestamp]
	return jsonTemplate.format(params, "{}")

class ChatMessageRegistration:
	func write(buffer: ByteBuffer, packet: _ChatMessage):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.avatar)
		buffer.writeLong(packet.id)
		buffer.writeString(packet.message)
		buffer.writeString(packet.name)
		buffer.writeLong(packet.sendId)
		buffer.writeLong(packet.timestamp)
		pass

	func read(buffer: ByteBuffer) -> _ChatMessage:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _ChatMessage = buffer.newInstance(4000)
		var result0 = buffer.readString()
		packet.avatar = result0
		var result1 = buffer.readLong()
		packet.id = result1
		var result2 = buffer.readString()
		packet.message = result2
		var result3 = buffer.readString()
		packet.name = result3
		var result4 = buffer.readLong()
		packet.sendId = result4
		var result5 = buffer.readLong()
		packet.timestamp = result5
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet