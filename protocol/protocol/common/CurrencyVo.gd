const PROTOCOL_ID = 401
const PROTOCOL_CLASS_NAME = "CurrencyVo"


var energy: int
var gem: int
var gold: int

func _to_string() -> String:
	const jsonTemplate = "{energy:{}, gem:{}, gold:{}}"
	var params = [self.energy, self.gem, self.gold]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeInt(packet.energy)
	buffer.writeInt(packet.gem)
	buffer.writeInt(packet.gold)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.energy = result0
	var result1 = buffer.readInt()
	packet.gem = result1
	var result2 = buffer.readInt()
	packet.gold = result2
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
