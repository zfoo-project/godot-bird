const PROTOCOL_ID = 4000


var id: int
var sendId: int
var avatar: String
var name: String
var message: String
var timestamp: int

func get_class() -> String:
	return "ChatMessage"

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeString(packet.avatar)
	buffer.writeLong(packet.id)
	buffer.writeString(packet.message)
	buffer.writeString(packet.name)
	buffer.writeLong(packet.sendId)
	buffer.writeLong(packet.timestamp)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.avatar = result0
	var result1 = buffer.readLong()
	packet.id = result1
	var result2 = buffer.readString()
	packet.message = result2
	var result3 = buffer.readString()
	packet.name = result3
	var result4 = buffer.readLong()
	packet.sendId = result4
	var result5 = buffer.readLong()
	packet.timestamp = result5
	return packet
