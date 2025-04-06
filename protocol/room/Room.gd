class_name _Room

const ByteBuffer = preload("../ByteBuffer.gd")

# 房间基本信息
var id: int
# 房主
var owner: int
# 现有人数
var currentNums: int
# 创建时间
var createTime: int
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
	return 6013

func _to_string() -> String:
	const jsonTemplate = "{id:{}, owner:{}, currentNums:{}, createTime:{}, title:'{}', subTitle:'{}', description:'{}', visible:{}, password:'{}', icon:'{}', gameId:{}, maxNums:{}}"
	var params = [self.id, self.owner, self.currentNums, self.createTime, self.title, self.subTitle, self.description, self.visible, self.password, self.icon, self.gameId, self.maxNums]
	return jsonTemplate.format(params, "{}")

class RoomRegistration:
	func write(buffer: ByteBuffer, packet: _Room):
		if (packet == null):
			buffer.writeInt(0)
			return
		buffer.writeInt(-1)
		buffer.writeLong(packet.createTime)
		buffer.writeInt(packet.currentNums)
		buffer.writeString(packet.description)
		buffer.writeInt(packet.gameId)
		buffer.writeString(packet.icon)
		buffer.writeLong(packet.id)
		buffer.writeInt(packet.maxNums)
		buffer.writeLong(packet.owner)
		buffer.writeString(packet.password)
		buffer.writeString(packet.subTitle)
		buffer.writeString(packet.title)
		buffer.writeBool(packet.visible)
		pass

	func read(buffer: ByteBuffer) -> _Room:
		var length = buffer.readInt()
		if (length == 0):
			return null
		var beforeReadIndex = buffer.getReadOffset()
		var packet: _Room = buffer.newInstance(6013)
		var result0 = buffer.readLong()
		packet.createTime = result0
		var result1 = buffer.readInt()
		packet.currentNums = result1
		var result2 = buffer.readString()
		packet.description = result2
		var result3 = buffer.readInt()
		packet.gameId = result3
		var result4 = buffer.readString()
		packet.icon = result4
		var result5 = buffer.readLong()
		packet.id = result5
		var result6 = buffer.readInt()
		packet.maxNums = result6
		var result7 = buffer.readLong()
		packet.owner = result7
		var result8 = buffer.readString()
		packet.password = result8
		var result9 = buffer.readString()
		packet.subTitle = result9
		var result10 = buffer.readString()
		packet.title = result10
		var result11 = buffer.readBool() 
		packet.visible = result11
		if (length > 0):
			buffer.setReadOffset(beforeReadIndex + length)
		return packet