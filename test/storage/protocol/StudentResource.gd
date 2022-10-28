const User = preload("res://test/storage/protocol/User.gd")


var age: int
var courses: Array[String]
var id: int
var name: String
var score: float
var user: User
var users: Array[User]

const PROTOCOL_ID = 1

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.age)
	buffer.writeStringArray(packet.courses)
	buffer.writeInt(packet.id)
	buffer.writeString(packet.name)
	buffer.writeFloat(packet.score)
	buffer.writePacket(packet.user, 2)
	buffer.writePacketArray(packet.users, 2)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.age = result0
	var array1 = buffer.readStringArray()
	packet.courses = array1
	var result2 = buffer.readInt()
	packet.id = result2
	var result3 = buffer.readString()
	packet.name = result3
	var result4 = buffer.readFloat()
	packet.score = result4
	var result5 = buffer.readPacket(2)
	packet.user = result5
	var array6 = buffer.readPacketArray(2)
	packet.users = array6
	return packet
