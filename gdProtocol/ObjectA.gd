

var a # int
var m # java.util.Map<java.lang.Integer, java.lang.String>
var objectB # com.zfoo.protocol.packet.ObjectB

const PROTOCOL_ID = 0

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.a)
	buffer.writeIntStringMap(packet.m)
	buffer.writePacket(packet.objectB, 1)


static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.a = result0
	var map1 = buffer.readIntStringMap()
	packet.m = map1
	var result2 = buffer.readPacket(1)
	packet.objectB = result2
	return packet
