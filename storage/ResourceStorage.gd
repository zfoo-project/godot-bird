class_name ResourceStorage

const ByteBuffer = preload("./ByteBuffer.gd")
const GodotObjectResource = preload("./GodotObjectResource.gd")
const GodotCommonResource = preload("./GodotCommonResource.gd")


var objectResources: Dictionary[int, GodotObjectResource]
var commonResources: Dictionary[String, GodotCommonResource]

func protocolId() -> int:
	return 0

func _to_string() -> String:
	const jsonTemplate = "{objectResources:{}, commonResources:{}}"
	var params = [self.objectResources, self.commonResources]
	return jsonTemplate.format(params, "{}")

class ResourceStorageRegistration:
	func write(buffer: ByteBuffer, packet: ResourceStorage):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeStringPacketMap(packet.commonResources, 2)
		buffer.writeIntPacketMap(packet.objectResources, 1)
		pass

	func read(buffer: ByteBuffer) -> ResourceStorage:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: ResourceStorage = buffer.newInstance(0)
		var map0 = buffer.readStringPacketMap(2)
		packet.commonResources = map0
		var map1 = buffer.readIntPacketMap(1)
		packet.objectResources = map1
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet