class_name _AdminPlayerLevelAsk

const ByteBuffer = preload("../ByteBuffer.gd")


var userId: int
var playerLevel: int
var playerExp: int

func protocolId() -> int:
	return 1200

func _to_string() -> String:
	const jsonTemplate = "{userId:{}, playerLevel:{}, playerExp:{}}"
	var params = [self.userId, self.playerLevel, self.playerExp]
	return jsonTemplate.format(params, "{}")

class AdminPlayerLevelAskRegistration:
	func write(buffer: ByteBuffer, packet: _AdminPlayerLevelAsk):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.playerExp)
		buffer.writeInt(packet.playerLevel)
		buffer.writeLong(packet.userId)
		pass

	func read(buffer: ByteBuffer) -> _AdminPlayerLevelAsk:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _AdminPlayerLevelAsk = buffer.newInstance(1200)
		var result0 = buffer.readInt()
		packet.playerExp = result0
		var result1 = buffer.readInt()
		packet.playerLevel = result1
		var result2 = buffer.readLong()
		packet.userId = result2
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet