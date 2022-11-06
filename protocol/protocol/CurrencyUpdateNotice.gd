const PROTOCOL_ID = 1100
const CurrencyVo = preload("res://protocol/protocol/common/CurrencyVo.gd")


var currencyVo: CurrencyVo

func get_class() -> String:
	return "CurrencyUpdateNotice"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacket(packet.currencyVo, 401)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(401)
	packet.currencyVo = result0
	return packet
