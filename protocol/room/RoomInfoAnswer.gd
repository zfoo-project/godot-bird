class_name _RoomInfoAnswer

const ByteBuffer = preload("../ByteBuffer.gd")
const Room = preload("./Room.gd")


var room: Room
var roomServerAddress: String

func protocolId() -> int:
	return 6015

func _to_string() -> String:
	const jsonTemplate = "{room:{}, roomServerAddress:'{}'}"
	var params = [self.room, self.roomServerAddress]
	return jsonTemplate.format(params, "{}")

class RoomInfoAnswerRegistration:
	func write(buffer: ByteBuffer, packet: _RoomInfoAnswer):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacket(packet.room, 6013)
		buffer.writeString(packet.roomServerAddress)
		pass

	func read(buffer: ByteBuffer) -> _RoomInfoAnswer:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _RoomInfoAnswer = buffer.newInstance(6015)
		var result0 = buffer.readPacket(6013)
		packet.room = result0
		var result1 = buffer.readString()
		packet.roomServerAddress = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet