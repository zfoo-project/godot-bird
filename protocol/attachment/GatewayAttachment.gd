class_name _GatewayAttachment

const ByteBuffer = preload("../ByteBuffer.gd")
const SignalAttachment = preload("./SignalAttachment.gd")


var sid: int
var uid: int
var taskExecutorHash: int
var client: bool
var signalAttachment: SignalAttachment

func protocolId() -> int:
	return 2

func _to_string() -> String:
	const jsonTemplate = "{sid:{}, uid:{}, taskExecutorHash:{}, client:{}, signalAttachment:{}}"
	var params = [self.sid, self.uid, self.taskExecutorHash, self.client, self.signalAttachment]
	return jsonTemplate.format(params, "{}")

class GatewayAttachmentRegistration:
	func write(buffer: ByteBuffer, packet: _GatewayAttachment):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeBool(packet.client)
		buffer.writeLong(packet.sid)
		buffer.writePacket(packet.signalAttachment, 0)
		buffer.writeInt(packet.taskExecutorHash)
		buffer.writeLong(packet.uid)
		pass

	func read(buffer: ByteBuffer) -> _GatewayAttachment:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _GatewayAttachment = buffer.newInstance(2)
		var result0 = buffer.readBool() 
		packet.client = result0
		var result1 = buffer.readLong()
		packet.sid = result1
		var result2 = buffer.readPacket(0)
		packet.signalAttachment = result2
		var result3 = buffer.readInt()
		packet.taskExecutorHash = result3
		var result4 = buffer.readLong()
		packet.uid = result4
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet
