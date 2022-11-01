

var module: int
var code: int
var message: String

const PROTOCOL_ID = 100

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.code)
	buffer.writeString(packet.message)
	buffer.writeByte(packet.module)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.code = result0
	var result1 = buffer.readString()
	packet.message = result1
	var result2 = buffer.readByte()
	packet.module = result2
	return packet
