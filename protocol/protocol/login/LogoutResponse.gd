const PROTOCOL_ID = 1003
const PROTOCOL_CLASS_NAME = "LogoutResponse"


var uid: int
var sid: int

func _to_string() -> String:
	const jsonTemplate = "{uid:{}, sid:{}}"
	var params = [self.uid, self.sid]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeLong(packet.sid)
	buffer.writeLong(packet.uid)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readLong()
	packet.sid = result0
	var result1 = buffer.readLong()
	packet.uid = result1
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
