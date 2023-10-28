const PROTOCOL_ID = 1101
const PROTOCOL_CLASS_NAME = "PlayerExpNotice"


var level: int
var exp: int

func _to_string() -> String:
	const jsonTemplate = "{level:{}, exp:{}}"
	var params = [self.level, self.exp]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeLong(packet.exp)
	buffer.writeInt(packet.level)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.exp = result0
	var result1 = buffer.readInt()
	packet.level = result1
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
