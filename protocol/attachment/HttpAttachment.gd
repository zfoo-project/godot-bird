

var uid: int
var useExecutorConsistentHash: bool
var executorConsistentHash: int

const PROTOCOL_ID = 3

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.executorConsistentHash)
	buffer.writeLong(packet.uid)
	buffer.writeBool(packet.useExecutorConsistentHash)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.executorConsistentHash = result0
	var result1 = buffer.readLong()
	packet.uid = result1
	var result2 = buffer.readBool() 
	packet.useExecutorConsistentHash = result2
	return packet
