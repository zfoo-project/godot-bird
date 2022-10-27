const ObjectA = preload("res://gdProtocol//ObjectA.gd")
const ObjectB = preload("res://gdProtocol//ObjectB.gd")
const ComplexObject = preload("res://gdProtocol//ComplexObject.gd")
const NormalObject = preload("res://gdProtocol//NormalObject.gd")
const SimpleObject = preload("res://gdProtocol//SimpleObject.gd")

const protocols: Dictionary = {
	0: ObjectA,
	1: ObjectB,
	100: ComplexObject,
	101: NormalObject,
	104: SimpleObject
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


