const PROTOCOL_ID = 3


var uid: int
var useTaskExecutorHashParam: bool
var taskExecutorHashParam: int

func toString() -> String:
	return "HttpAttachment"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.taskExecutorHashParam)
	buffer.writeLong(packet.uid)
	buffer.writeBool(packet.useTaskExecutorHashParam)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.taskExecutorHashParam = result0
	var result1 = buffer.readLong()
	packet.uid = result1
	var result2 = buffer.readBool() 
	packet.useTaskExecutorHashParam = result2
	return packet
