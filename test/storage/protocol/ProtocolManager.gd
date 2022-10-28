const ResourceData = preload("res://test/storage/protocol/ResourceData.gd")
const StudentResource = preload("res://test/storage/protocol/StudentResource.gd")
const User = preload("res://test/storage/protocol/User.gd")

const protocols: Dictionary = {
	0: ResourceData,
	1: StudentResource,
	2: User
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
