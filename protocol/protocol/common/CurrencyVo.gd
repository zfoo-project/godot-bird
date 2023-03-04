const PROTOCOL_ID = 401


var energy: int
var gem: int
var gold: int

func toString() -> String:
	return "CurrencyVo"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.energy)
	buffer.writeInt(packet.gem)
	buffer.writeInt(packet.gold)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.energy = result0
	var result1 = buffer.readInt()
	packet.gem = result1
	var result2 = buffer.readInt()
	packet.gold = result2
	return packet
