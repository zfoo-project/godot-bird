class_name _CurrencyVo

const ByteBuffer = preload("../ByteBuffer.gd")


var energy: int
var gem: int
var gold: int

func protocolId() -> int:
	return 401

func _to_string() -> String:
	const jsonTemplate = "{energy:{}, gem:{}, gold:{}}"
	var params = [self.energy, self.gem, self.gold]
	return jsonTemplate.format(params, "{}")

class CurrencyVoRegistration:
	func write(buffer: ByteBuffer, packet: _CurrencyVo):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeInt(packet.energy)
		buffer.writeInt(packet.gem)
		buffer.writeInt(packet.gold)
		pass

	func read(buffer: ByteBuffer) -> _CurrencyVo:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _CurrencyVo = buffer.newInstance(401)
		var result0 = buffer.readInt()
		packet.energy = result0
		var result1 = buffer.readInt()
		packet.gem = result1
		var result2 = buffer.readInt()
		packet.gold = result2
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet