const StudentResource = preload("res://test/storage/protocol/StudentResource.gd")
const User = preload("res://test/storage/protocol/User.gd")


var studentResources: Dictionary

const PROTOCOL_ID = 0

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeIntPacketMap(packet.studentResources, 1)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var map0 = buffer.readIntPacketMap(1)
	packet.studentResources = map0
	return packet
