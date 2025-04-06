class_name _AdminCurrencyAsk

const ByteBuffer = preload("../ByteBuffer.gd")


var userId: int
var gold: int
var gem: int
var energy: int

func protocolId() -> int:
	return 1201

func _to_string() -> String:
	const jsonTemplate = "{userId:{}, gold:{}, gem:{}, energy:{}}"
	var params = [self.userId, self.gold, self.gem, self.energy]
	return jsonTemplate.format(params, "{}")

class AdminCurrencyAskRegistration:
	func write(buffer: ByteBuffer, packet: _AdminCurrencyAsk):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.energy)
		buffer.writeInt(packet.gem)
		buffer.writeInt(packet.gold)
		buffer.writeLong(packet.userId)
		pass

	func read(buffer: ByteBuffer) -> _AdminCurrencyAsk:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _AdminCurrencyAsk = buffer.newInstance(1201)
		var result0 = buffer.readInt()
		packet.energy = result0
		var result1 = buffer.readInt()
		packet.gem = result1
		var result2 = buffer.readInt()
		packet.gold = result2
		var result3 = buffer.readLong()
		packet.userId = result3
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet