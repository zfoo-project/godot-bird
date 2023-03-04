const PROTOCOL_ID = 0


var signalId: int
var taskExecutorHash: int
var client: bool

func toString() -> String:
	return "SignalAttachment"

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
