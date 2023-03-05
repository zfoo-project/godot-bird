const PROTOCOL_ID = 4
const PROTOCOL_CLASS_NAME = "NoAnswerAttachment"


var taskExecutorHash: int

func map() -> Dictionary:
	var map = {}
	map["taskExecutorHash"] = taskExecutorHash
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.taskExecutorHash)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.taskExecutorHash = result0
	return packet
