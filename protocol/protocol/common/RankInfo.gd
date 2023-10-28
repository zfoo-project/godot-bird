const PROTOCOL_ID = 402
const PROTOCOL_CLASS_NAME = "RankInfo"
const PlayerInfo = preload("res://protocol/protocol/common/PlayerInfo.gd")


var playerInfo: PlayerInfo
var time: int
var score: int

func _to_string() -> String:
	const jsonTemplate = "{playerInfo:{}, time:{}, score:{}}"
	var params = [self.playerInfo, self.time, self.score]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writePacket(packet.playerInfo, 400)
	buffer.writeInt(packet.score)
	buffer.writeLong(packet.time)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readPacket(400)
	packet.playerInfo = result0
	var result1 = buffer.readInt()
	packet.score = result1
	var result2 = buffer.readLong()
	packet.time = result2
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
