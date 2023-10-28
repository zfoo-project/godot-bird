const PROTOCOL_ID = 1005
const PROTOCOL_CLASS_NAME = "GetPlayerInfoResponse"
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")
const CurrencyVo = preload("res://protocol/protocol/common/CurrencyVo.gd")


var playerInfo: PlayerInfo
var currencyVo: CurrencyVo

func _to_string() -> String:
	const jsonTemplate = "{playerInfo:{}, currencyVo:{}}"
	var params = [self.playerInfo, self.currencyVo]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writePacket(packet.currencyVo, 401)
	buffer.writePacket(packet.playerInfo, 400)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(401)
	packet.currencyVo = result0
	var result1 = buffer.readPacket(400)
	packet.playerInfo = result1
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
