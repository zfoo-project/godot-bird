const GodotCommonResource = preload("res://storage/GodotCommonResource.gd")
const GodotObjectResource = preload("res://storage/GodotObjectResource.gd")
const ResourceStorage = preload("res://storage/ResourceStorage.gd")

const protocols: Dictionary = {
	0: GodotCommonResource,
	1: GodotObjectResource,
	2: ResourceStorage
}

static func getProtocol(protocolId: int):
	return protocols[protocolId]

static func newInstance(protocolId: int):
	var protocol = protocols[protocolId]
	return protocol.new()

static func write(buffer, packet):
	var protocolId: int = packet.PROTOCOL_ID
	buffer.writeShort(protocolId)
	var protocol = protocols[protocolId]
	protocol.write(buffer, packet)

static func read(buffer):
	var protocolId = buffer.readShort();
	var protocol = protocols[protocolId]
	var packet = protocol.read(buffer);
	return packet;
