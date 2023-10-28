const PROTOCOL_ID = 400
const PROTOCOL_CLASS_NAME = "PlayerInfo"


var id: int
var name: String
var avatar: String
var level: int
var exp: int

func _to_string() -> String:
	const jsonTemplate = "{id:{}, name:'{}', avatar:'{}', level:{}, exp:{}}"
	var params = [self.id, self.name, self.avatar, self.level, self.exp]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeString(packet.avatar)
	buffer.writeLong(packet.exp)
	buffer.writeLong(packet.id)
	buffer.writeInt(packet.level)
	buffer.writeString(packet.name)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readString()
	packet.avatar = result0
	var result1 = buffer.readLong()
	packet.exp = result1
	var result2 = buffer.readLong()
	packet.id = result2
	var result3 = buffer.readInt()
	packet.level = result3
	var result4 = buffer.readString()
	packet.name = result4
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
