class_name _CreateRoomRequest

const ByteBuffer = preload("../ByteBuffer.gd")

# 匹配玩家的基本信息
var title: String
var subTitle: String
var description: String
# 公开或者私密
var visible: bool
var password: String
var icon: String
# 游戏类型
var gameId: int
# 游戏人数
var maxNums: int

func protocolId() -> int:
	return 1500

func _to_string() -> String:
	const jsonTemplate = "{title:'{}', subTitle:'{}', description:'{}', visible:{}, password:'{}', icon:'{}', gameId:{}, maxNums:{}}"
	var params = [self.title, self.subTitle, self.description, self.visible, self.password, self.icon, self.gameId, self.maxNums]
	return jsonTemplate.format(params, "{}")

class CreateRoomRequestRegistration:
	func write(buffer: ByteBuffer, packet: _CreateRoomRequest):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeString(packet.description)
		buffer.writeInt(packet.gameId)
		buffer.writeString(packet.icon)
		buffer.writeInt(packet.maxNums)
		buffer.writeString(packet.password)
		buffer.writeString(packet.subTitle)
		buffer.writeString(packet.title)
		buffer.writeBool(packet.visible)
		pass

	func read(buffer: ByteBuffer) -> _CreateRoomRequest:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _CreateRoomRequest = buffer.newInstance(1500)
		var result0 = buffer.readString()
		packet.description = result0
		var result1 = buffer.readInt()
		packet.gameId = result1
		var result2 = buffer.readString()
		packet.icon = result2
		var result3 = buffer.readInt()
		packet.maxNums = result3
		var result4 = buffer.readString()
		packet.password = result4
		var result5 = buffer.readString()
		packet.subTitle = result5
		var result6 = buffer.readString()
		packet.title = result6
		var result7 = buffer.readBool() 
		packet.visible = result7
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet