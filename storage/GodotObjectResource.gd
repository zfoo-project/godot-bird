class_name GodotObjectResource

const ByteBuffer = preload("./ByteBuffer.gd")


var id: int
var path: String
var randomUpY: float
var randomDownY: float
var forwardX: float
var refreshTime: float
var refreshMinTime: float
var refreshAccelerate: float
var signalBind: String
var callback: String

func protocolId() -> int:
	return 1

func _to_string() -> String:
	const jsonTemplate = "{id:{}, path:'{}', randomUpY:{}, randomDownY:{}, forwardX:{}, refreshTime:{}, refreshMinTime:{}, refreshAccelerate:{}, signalBind:'{}', callback:'{}'}"
	var params = [self.id, self.path, self.randomUpY, self.randomDownY, self.forwardX, self.refreshTime, self.refreshMinTime, self.refreshAccelerate, self.signalBind, self.callback]
	return jsonTemplate.format(params, "{}")

class GodotObjectResourceRegistration:
	func write(buffer: ByteBuffer, packet: GodotObjectResource):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.callback)
		buffer.writeFloat(packet.forwardX)
		buffer.writeInt(packet.id)
		buffer.writeString(packet.path)
		buffer.writeFloat(packet.randomDownY)
		buffer.writeFloat(packet.randomUpY)
		buffer.writeFloat(packet.refreshAccelerate)
		buffer.writeFloat(packet.refreshMinTime)
		buffer.writeFloat(packet.refreshTime)
		buffer.writeString(packet.signalBind)
		pass

	func read(buffer: ByteBuffer) -> GodotObjectResource:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: GodotObjectResource = buffer.newInstance(1)
		var result0 = buffer.readString()
		packet.callback = result0
		var result1 = buffer.readFloat()
		packet.forwardX = result1
		var result2 = buffer.readInt()
		packet.id = result2
		var result3 = buffer.readString()
		packet.path = result3
		var result4 = buffer.readFloat()
		packet.randomDownY = result4
		var result5 = buffer.readFloat()
		packet.randomUpY = result5
		var result6 = buffer.readFloat()
		packet.refreshAccelerate = result6
		var result7 = buffer.readFloat()
		packet.refreshMinTime = result7
		var result8 = buffer.readFloat()
		packet.refreshTime = result8
		var result9 = buffer.readString()
		packet.signalBind = result9
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet