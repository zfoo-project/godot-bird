

var age: int
var id: String
var name: String
var sex: String

const PROTOCOL_ID = 2

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.age)
	buffer.writeString(packet.id)
	buffer.writeString(packet.name)
	buffer.writeString(packet.sex)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.age = result0
	var result1 = buffer.readString()
	packet.id = result1
	var result2 = buffer.readString()
	packet.name = result2
	var result3 = buffer.readString()
	packet.sex = result3
	return packet
