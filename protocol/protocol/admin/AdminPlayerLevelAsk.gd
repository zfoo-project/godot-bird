const PROTOCOL_ID = 1200


var userId: int
var playerLevel: int
var playerExp: int

func get_class() -> String:
	return "AdminPlayerLevelAsk"

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
