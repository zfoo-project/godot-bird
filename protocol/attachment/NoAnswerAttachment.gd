const PROTOCOL_ID = 4


var executorConsistentHash: int

func get_class() -> String:
	return "NoAnswerAttachment"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.executorConsistentHash)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.executorConsistentHash = result0
	return packet
