class_name _CurrencyUpdateNotice

const ByteBuffer = preload("../ByteBuffer.gd")
const CurrencyVo = preload("../common/CurrencyVo.gd")


var currencyVo: CurrencyVo

func protocolId() -> int:
	return 1100

func _to_string() -> String:
	const jsonTemplate = "{currencyVo:{}}"
	var params = [self.currencyVo]
	return jsonTemplate.format(params, "{}")

class CurrencyUpdateNoticeRegistration:
	func write(buffer: ByteBuffer, packet: _CurrencyUpdateNotice):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacket(packet.currencyVo, 401)
		pass

	func read(buffer: ByteBuffer) -> _CurrencyUpdateNotice:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _CurrencyUpdateNotice = buffer.newInstance(1100)
		var result0 = buffer.readPacket(401)
		packet.currencyVo = result0
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet