const PROTOCOL_ID = 1
const PROTOCOL_CLASS_NAME = "GatewayAttachment"
const SignalAttachment = preload("res://protocol/attachment/SignalAttachment.gd")


var sid: int
var uid: int
var useTaskExecutorHashParam: bool
var taskExecutorHashParam: int
var client: bool
var signalAttachment: SignalAttachment

func map() -> Dictionary:
	var map = {}
	map["sid"] = sid
	map["uid"] = uid
	map["useTaskExecutorHashParam"] = useTaskExecutorHashParam
	map["taskExecutorHashParam"] = taskExecutorHashParam
	map["client"] = client
	map["signalAttachment"] = signalAttachment
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeBool(packet.client)
	buffer.writeLong(packet.sid)
	buffer.writePacket(packet.signalAttachment, 0)
	buffer.writeInt(packet.taskExecutorHashParam)
	buffer.writeLong(packet.uid)
	buffer.writeBool(packet.useTaskExecutorHashParam)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readBool() 
	packet.client = result0
	var result1 = buffer.readLong()
	packet.sid = result1
	var result2 = buffer.readPacket(0)
	packet.signalAttachment = result2
	var result3 = buffer.readInt()
	packet.taskExecutorHashParam = result3
	var result4 = buffer.readLong()
	packet.uid = result4
	var result5 = buffer.readBool() 
	packet.useTaskExecutorHashParam = result5
	return packet
