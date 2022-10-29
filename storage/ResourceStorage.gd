const GodotCommonResource = preload("res://storage/GodotCommonResource.gd")
const GodotObjectResource = preload("res://storage/GodotObjectResource.gd")


# Map<Integer, GodotResource>
var objectResources: Dictionary
# Map<String, GodotCommonResource>
var commonResources: Dictionary

const PROTOCOL_ID = 2

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeStringPacketMap(packet.commonResources, 0)
	buffer.writeIntPacketMap(packet.objectResources, 1)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var map0 = buffer.readStringPacketMap(0)
	packet.commonResources = map0
	var map1 = buffer.readIntPacketMap(1)
	packet.objectResources = map1
	return packet
