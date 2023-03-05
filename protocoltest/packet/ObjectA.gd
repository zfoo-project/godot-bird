const PROTOCOL_ID = 102
const PROTOCOL_CLASS_NAME = "ObjectA"
const ObjectB = preload("res://protocoltest/packet/ObjectB.gd")


var a: int
var m: Dictionary
var objectB: ObjectB

func map() -> Dictionary:
	var map = {}
	map["a"] = a
	map["m"] = m
	map["objectB"] = objectB
	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	buffer.writeInt(packet.a)
	buffer.writeIntStringMap(packet.m)
	buffer.writePacket(packet.objectB, 103)

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.a = result0
	var map1 = buffer.readIntStringMap()
	packet.m = map1
	var result2 = buffer.readPacket(103)
	packet.objectB = result2
	return packet
