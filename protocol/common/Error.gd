const PROTOCOL_ID = 101
const PROTOCOL_CLASS_NAME = "Error"


var module: int
var errorCode: int
var errorMessage: String

func _to_string() -> String:
	const jsonTemplate = "{module:{}, errorCode:{}, errorMessage:'{}'}"
	var params = [self.module, self.errorCode, self.errorMessage]
	return jsonTemplate.format(params, "{}")

static func write(buffer, packet):
	if (packet == null):
		buffer.writeInt(0)
		return
	buffer.writeInt(-1)
	buffer.writeInt(packet.errorCode)
	buffer.writeString(packet.errorMessage)
	buffer.writeInt(packet.module)
	pass

static func read(buffer):
	var length = buffer.readInt()
	if (length == 0):
		return null
	var beforeReadIndex = buffer.getReadOffset()
	var packet = buffer.newInstance(PROTOCOL_ID)
	var result0 = buffer.readInt()
	packet.errorCode = result0
	var result1 = buffer.readString()
	packet.errorMessage = result1
	var result2 = buffer.readInt()
	packet.module = result2
	if (length > 0):
		buffer.setReadOffset(beforeReadIndex + length)
	return packet
