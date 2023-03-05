const PROTOCOL_ID = 0
const PROTOCOL_CLASS_NAME = "SignalAttachment"


var signalId: int
var taskExecutorHash: int
var client: bool

func map() -> Dictionary:
	var map = {}
	map["signalId"] = signalId
	map["taskExecutorHash"] = taskExecutorHash
	map["client"] = client
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeBool(packet.client)
	buffer.writeInt(packet.signalId)
	buffer.writeInt(packet.taskExecutorHash)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readBool() 
	packet.client = result0
	var result1 = buffer.readInt()
	packet.signalId = result1
	var result2 = buffer.readInt()
	packet.taskExecutorHash = result2
	return packet
