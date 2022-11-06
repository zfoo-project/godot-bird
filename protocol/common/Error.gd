const PROTOCOL_ID = 101


var module: int
var errorCode: int
var errorMessage: String

func get_class() -> String:
	return "Error"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.errorCode)
	buffer.writeString(packet.errorMessage)
	buffer.writeInt(packet.module)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.errorCode = result0
	var result1 = buffer.readString()
	packet.errorMessage = result1
	var result2 = buffer.readInt()
	packet.module = result2
	return packet
