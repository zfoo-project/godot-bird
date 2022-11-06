const PROTOCOL_ID = 0


var signalId: int
var executorConsistentHash: int
var client: bool

func get_class() -> String:
	return "SignalAttachment"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeBool(packet.client)
	buffer.writeInt(packet.executorConsistentHash)
	buffer.writeInt(packet.signalId)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readBool() 
	packet.client = result0
	var result1 = buffer.readInt()
	packet.executorConsistentHash = result1
	var result2 = buffer.readInt()
	packet.signalId = result2
	return packet
