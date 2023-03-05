const PROTOCOL_ID = 3002
const PROTOCOL_CLASS_NAME = "ScoreRankRequest"




func map() -> Dictionary:
	var map = {}

	return map

func _to_string() -> String:
	return JSON.stringify(map())

static func write(buffer, packet):
	if (buffer.writePacketFlag(packet)):
		return
	

static func read(buffer):
	if (!buffer.readBool()):
		return null
	var packet = buffer.newInstance(PROTOCOL_ID)
	
	return packet
