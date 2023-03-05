const PROTOCOL_ID = 1005
const PROTOCOL_CLASS_NAME = "GetPlayerInfoResponse"
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")
const CurrencyVo = preload("res://protocol/protocol/common/CurrencyVo.gd")


var playerInfo: PlayerInfo
var currencyVo: CurrencyVo

func map() -> Dictionary:
	var map = {}
	map["playerInfo"] = playerInfo
	map["currencyVo"] = currencyVo
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacket(packet.currencyVo, 401)
	buffer.writePacket(packet.playerInfo, 400)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(401)
	packet.currencyVo = result0
	var result1 = buffer.readPacket(400)
	packet.playerInfo = result1
	return packet
