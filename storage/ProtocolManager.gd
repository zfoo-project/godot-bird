const ByteBuffer = preload("./ByteBuffer.gd")
const ResourceStorage = preload("./ResourceStorage.gd")
const GodotObjectResource = preload("./GodotObjectResource.gd")
const GodotCommonResource = preload("./GodotCommonResource.gd")

static var protocols: Dictionary[int, RefCounted] = {}
static var protocolClassMap: Dictionary[int, Object] = {}

static func initProtocol():
	protocols[0] = ResourceStorage.ResourceStorageRegistration.new()
	protocolClassMap[0] = ResourceStorage
	protocols[1] = GodotObjectResource.GodotObjectResourceRegistration.new()
	protocolClassMap[1] = GodotObjectResource
	protocols[2] = GodotCommonResource.GodotCommonResourceRegistration.new()
	protocolClassMap[2] = GodotCommonResource
	pass

static func getProtocol(protocolId: int):
	return protocols[protocolId]

static func getProtocolClass(protocolId: int):
	return protocolClassMap[protocolId]

static func newInstance(protocolId: int):
	var protocol = protocolClassMap[protocolId]
	return protocol.new()

static func write(buffer, packet):
	var protocolId: int = packet.protocolId()
	buffer.writeShort(protocolId)
	var protocol = protocols[protocolId]
	protocol.write(buffer, packet)

static func read(buffer):
	var protocolId = buffer.readShort()
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer)
	return packet