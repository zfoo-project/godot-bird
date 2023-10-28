const PROTOCOL_ID = 1100
const PROTOCOL_CLASS_NAME = "CurrencyUpdateNotice"
const CurrencyVo = preload("res://protocol/protocol/common/CurrencyVo.gd")


var currencyVo: CurrencyVo

func _to_string() -> String:
	const jsonTemplate = "{currencyVo:{}}"
	var params = [self.currencyVo]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writePacket(packet.currencyVo, 401)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(401)
	packet.currencyVo = result0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
