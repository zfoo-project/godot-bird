const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")


var playerInfo: PlayerInfo
var time: int
var score: int

const PROTOCOL_ID = 402

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writePacket(packet.playerInfo, 400)
	buffer.writeInt(packet.score)
	buffer.writeLong(packet.time)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(400)
	packet.playerInfo = result0
	var result1 = buffer.readInt()
	packet.score = result1
	var result2 = buffer.readLong()
	packet.time = result2
	return packet
