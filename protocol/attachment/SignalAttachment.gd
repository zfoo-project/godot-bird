const PROTOCOL_ID = 0
const PROTOCOL_CLASS_NAME = "SignalAttachment"


var signalId: int
var taskExecutorHash: int
# 0 for the server, 1 or 2 for the sync or async native client, 12 for the outside client such as browser, mobile
var client: int
var timestamp: int

func _to_string() -> String:
	const jsonTemplate = "{signalId:{}, taskExecutorHash:{}, client:{}, timestamp:{}}"
	var params = [self.signalId, self.taskExecutorHash, self.client, self.timestamp]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeByte(packet.client)
	buffer.writeInt(packet.signalId)
	buffer.writeInt(packet.taskExecutorHash)
	buffer.writeLong(packet.timestamp)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readByte()
	packet.client = result0
	var result1 = buffer.readInt()
	packet.signalId = result1
	var result2 = buffer.readInt()
	packet.taskExecutorHash = result2
	var result3 = buffer.readLong()
	packet.timestamp = result3
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
