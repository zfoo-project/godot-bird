const PROTOCOL_ID = 4


var taskExecutorHash: int

func toString() -> String:
	return "NoAnswerAttachment"

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
