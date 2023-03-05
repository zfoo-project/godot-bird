const PROTOCOL_ID = 1200
const PROTOCOL_CLASS_NAME = "AdminPlayerLevelAsk"


var userId: int
var playerLevel: int
var playerExp: int

func map() -> Dictionary:
	var map = {}
	map["userId"] = userId
	map["playerLevel"] = playerLevel
	map["playerExp"] = playerExp
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.playerExp)
	buffer.writeInt(packet.playerLevel)
	buffer.writeLong(packet.userId)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.playerExp = result0
	var result1 = buffer.readInt()
	packet.playerLevel = result1
	var result2 = buffer.readLong()
	packet.userId = result2
	return packet
