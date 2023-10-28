const PROTOCOL_ID = 111
const PROTOCOL_CLASS_NAME = "PairLong"


var key: int
var value: int

func _to_string() -> String:
	const jsonTemplate = "{key:{}, value:{}}"
	var params = [self.key, self.value]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeLong(packet.key)
	buffer.writeLong(packet.value)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.key = result0
	var result1 = buffer.readLong()
	packet.value = result1
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
