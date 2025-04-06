class_name _JoinRoomResponse

const ByteBuffer = preload("../ByteBuffer.gd")
const Room = preload("./Room.gd")


var room: Room

func protocolId() -> int:
	return 6012

func _to_string() -> String:
	const jsonTemplate = "{room:{}}"
	var params = [self.room]
	return jsonTemplate.format(params, "{}")

class JoinRoomResponseRegistration:
	func write(buffer: ByteBuffer, packet: _JoinRoomResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacket(packet.room, 6013)
		pass

	func read(buffer: ByteBuffer) -> _JoinRoomResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _JoinRoomResponse = buffer.newInstance(6012)
		var result0 = buffer.readPacket(6013)
		packet.room = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet