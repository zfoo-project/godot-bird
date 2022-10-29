const GodotResource = preload("res://storage/GodotResource.gd")


# Map<Integer, GodotResource>
var godotResources: Dictionary

const PROTOCOL_ID = 1

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeIntPacketMap(packet.godotResources, 0)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var map0 = buffer.readIntPacketMap(0)
	packet.godotResources = map0
	return packet
