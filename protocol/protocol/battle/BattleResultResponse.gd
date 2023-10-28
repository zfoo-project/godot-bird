const PROTOCOL_ID = 1007
const PROTOCOL_CLASS_NAME = "BattleResultResponse"


var score: int

func _to_string() -> String:
	const jsonTemplate = "{score:{}}"
	var params = [self.score]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeInt(packet.score)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.score = result0
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
