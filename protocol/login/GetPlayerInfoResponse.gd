class_name _GetPlayerInfoResponse

const ByteBuffer = preload("../ByteBuffer.gd")
const PlayerInfo = preload("../common/PlayerInfo.gd")
const CurrencyVo = preload("../common/CurrencyVo.gd")


var playerInfo: PlayerInfo
var currencyVo: CurrencyVo

func protocolId() -> int:
	return 1005

func _to_string() -> String:
	const jsonTemplate = "{playerInfo:{}, currencyVo:{}}"
	var params = [self.playerInfo, self.currencyVo]
	return jsonTemplate.format(params, "{}")

class GetPlayerInfoResponseRegistration:
	func write(buffer: ByteBuffer, packet: _GetPlayerInfoResponse):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writePacket(packet.currencyVo, 401)
		buffer.writePacket(packet.playerInfo, 400)
		pass

	func read(buffer: ByteBuffer) -> _GetPlayerInfoResponse:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GetPlayerInfoResponse = buffer.newInstance(1005)
		var result0 = buffer.readPacket(401)
		packet.currencyVo = result0
		var result1 = buffer.readPacket(400)
		packet.playerInfo = result1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet