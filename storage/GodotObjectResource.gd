

var id: int
var path: String
var randomUpY: float
var randomDownY: float
var forwardX: float
var refreshTime: float
var refreshMinTime: float
var refreshAccelerate: float
var signalBind: String
var callback: String

const PROTOCOL_ID = 1

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.callback)
	buffer.writeFloat(packet.forwardX)
	buffer.writeInt(packet.id)
	buffer.writeString(packet.path)
	buffer.writeFloat(packet.randomDownY)
	buffer.writeFloat(packet.randomUpY)
	buffer.writeFloat(packet.refreshAccelerate)
	buffer.writeFloat(packet.refreshMinTime)
	buffer.writeFloat(packet.refreshTime)
	buffer.writeString(packet.signalBind)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.callback = result0
	var result1 = buffer.readFloat()
	packet.forwardX = result1
	var result2 = buffer.readInt()
	packet.id = result2
	var result3 = buffer.readString()
	packet.path = result3
	var result4 = buffer.readFloat()
	packet.randomDownY = result4
	var result5 = buffer.readFloat()
	packet.randomUpY = result5
	var result6 = buffer.readFloat()
	packet.refreshAccelerate = result6
	var result7 = buffer.readFloat()
	packet.refreshMinTime = result7
	var result8 = buffer.readFloat()
	packet.refreshTime = result8
	var result9 = buffer.readString()
	packet.signalBind = result9
	return packet
