const PROTOCOL_ID = 1201


var userId: int
var gold: int
var gem: int
var energy: int

func toString() -> String:
	return "AdminCurrencyAsk"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.energy)
	buffer.writeInt(packet.gem)
	buffer.writeInt(packet.gold)
	buffer.writeLong(packet.userId)

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
	var result3 = buffer.readLong()
	packet.userId = result3
	return packet
