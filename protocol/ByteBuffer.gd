const ProtocolManager = preload("./ProtocolManager.gd")

const EMPTY: String = ""

const maxInt: int = 2147483647
const minInt: int = -2147483648

var buffer = StreamPeerBuffer.new()

var writeOffset: int = 0
var readOffset: int = 0

func _init():
	buffer.big_endian = true

func adjustPadding(predictionLength: int, beforeWriteIndex: int):
	var currentWriteIndex = writeOffset
	var predictionCount = writeIntCount(predictionLength)
	var length = currentWriteIndex - beforeWriteIndex - predictionCount
	var lengthCount = writeIntCount(length)
	var padding = lengthCount - predictionCount
	if padding == 0:
		setWriteOffset(beforeWriteIndex)
		writeInt(length)
		setWriteOffset(currentWriteIndex)
	else:
		# get_partial_data of StreamPeerBuffer is deep clone
		buffer.seek(currentWriteIndex - length)
		var retainedByteBuf = buffer.get_partial_data(length)[1]
		setWriteOffset(beforeWriteIndex)
		writeInt(length)
		buffer.seek(beforeWriteIndex + lengthCount)
		buffer.put_partial_data(retainedByteBuf)
		var count = beforeWriteIndex + lengthCount + length
		buffer.seek(count)
		setWriteOffset(count)
	pass

func compatibleRead(beforeReadIndex: int, length: int) -> bool:
	return length != -1 && getReadOffset() < length + beforeReadIndex

# -------------------------------------------------get/set-------------------------------------------------
func getBuffer() -> StreamPeerBuffer:
	return buffer

func setWriteOffset(writeIndex: int):
	if (writeIndex > buffer.get_size()):
		var template = "writeIndex[{}] out of bounds exception: readOffset: {}, writeOffset: {} (expected: 0 <= readOffset <= writeOffset <= capacity: {})"
		printerr(template.format([writeIndex, readOffset, writeOffset, buffer.get_size()], "{}"))
		return
	writeOffset = writeIndex
	pass

func getWriteOffset() -> int:
	return writeOffset

func setReadOffset(readIndex: int):
	if (readIndex > writeOffset):
		var template = "readIndex[{}] out of bounds exception: readOffset: {}, writeOffset: {} (expected: 0 <= readOffset <= writeOffset <= capacity: {})"
		printerr(template.format([readIndex, readOffset, writeOffset, buffer.size()], "{}"))
		return
	readOffset = readIndex
	pass

func getReadOffset() -> int:
	return readOffset

func isReadable() -> bool:
	return writeOffset > readOffset

func toBytes() -> PackedByteArray:
	return buffer.data_array.slice(0, writeOffset)

func newInstance(protocolId: int) -> Object:
	return ProtocolManager.newInstance(protocolId)

# -------------------------------------------------write/read-------------------------------------------------
func writeBytes(value: PackedByteArray):
	var length: int = value.size()
	buffer.put_partial_data(value)
	writeOffset += length
	pass

func readBytes(length: int) -> PackedByteArray:
	return buffer.data_array.slice(0, length)

func writeBool(value: bool):
	var byte: int = 1 if value else 0
	buffer.seek(writeOffset)
	buffer.put_8(byte)
	writeOffset += 1
	pass

func readBool() -> bool:
	buffer.seek(readOffset)
	var byte: int = buffer.get_8()
	readOffset += 1
	return byte == 1

func writeByte(value: int):
	buffer.seek(writeOffset)
	buffer.put_8(value)
	writeOffset += 1
	pass

func readByte() -> int:
	buffer.seek(readOffset)
	var value: int = buffer.get_8()
	readOffset += 1
	return value

func writeShort(value: int):
	buffer.seek(writeOffset)
	buffer.put_16(value)
	writeOffset += 2
	pass

func readShort() -> int:
	buffer.seek(readOffset)
	var value = buffer.get_16()
	readOffset += 2
	return value

func writeRawInt(value):
	buffer.seek(writeOffset)
	buffer.put_32(value)
	writeOffset += 4
	pass

func readRawInt() -> int:
	buffer.seek(readOffset)
	var value = buffer.get_32()
	readOffset += 4
	return value

func writeInt(value):
	if !(minInt <= value && value <= maxInt):
		printerr("value must range between minInt:-2147483648 and maxInt:2147483647")
		return
	writeLong(value)
	pass

func writeIntCount(value: int) -> int:
	if !(minInt <= value && value <= maxInt):
		printerr("value must range between minInt:-2147483648 and maxInt:2147483647")
		return 0
	value = (value << 1) ^ (value >> 63)
	if value >> 7 == 0:
		return 1
	if value >> 14 == 0:
		return 2
	if value >> 21 == 0:
		return 3
	if value >> 28 == 0:
		return 4
	return 5

func readInt() -> int:
	return readLong()

func writeLong(longValue: int):
	var value: int = (longValue << 1) ^ (longValue >> 63)

	if (value >> 7 == 0):
		writeByte(value)
		return
	if (value >> 14 == 0):
		writeByte(value | 0x80)
		writeByte(value >> 7)
		return
	if (value >> 21 == 0):
		writeByte(value | 0x80)
		writeByte((value >> 7) | 0x80)
		writeByte(value >> 14)
		return
	if (value >> 28 == 0):
		writeByte(value | 0x80)
		writeByte((value >> 7) | 0x80)
		writeByte((value >> 14) | 0x80)
		writeByte(value >> 21)
		return
	if (value >> 35 == 0):
		writeByte(value | 0x80)
		writeByte((value >> 7) | 0x80)
		writeByte((value >> 14) | 0x80)
		writeByte((value >> 21) | 0x80)
		writeByte(value >> 28)
		return
	if (value >> 42 == 0):
		writeByte(value | 0x80)
		writeByte((value >> 7) | 0x80)
		writeByte((value >> 14) | 0x80)
		writeByte((value >> 21) | 0x80)
		writeByte((value >> 28) | 0x80)
		writeByte(value >> 35)
		return
	if (value >> 49 == 0):
		writeByte(value | 0x80)
		writeByte((value >> 7) | 0x80)
		writeByte((value >> 14) | 0x80)
		writeByte((value >> 21) | 0x80)
		writeByte((value >> 28) | 0x80)
		writeByte((value >> 35) | 0x80)
		writeByte(value >> 42)
		return
	if (value >> 56 == 0):
		writeByte(value | 0x80)
		writeByte((value >> 7) | 0x80)
		writeByte((value >> 14) | 0x80)
		writeByte((value >> 21) | 0x80)
		writeByte((value >> 28) | 0x80)
		writeByte((value >> 35) | 0x80)
		writeByte((value >> 42) | 0x80)
		writeByte(value >> 49)
		return
	writeByte(value | 0x80)
	writeByte((value >> 7) | 0x80)
	writeByte((value >> 14) | 0x80)
	writeByte((value >> 21) | 0x80)
	writeByte((value >> 28) | 0x80)
	writeByte((value >> 35) | 0x80)
	writeByte((value >> 42) | 0x80)
	writeByte((value >> 49) | 0x80)
	writeByte(value >> 56)
	pass

func readLong() -> int:
	var byte: int = readByte()
	var value: int = byte
	if (byte < 0):
		byte = readByte()
		value = value & 0x00000000_0000007F | byte << 7
		if (byte < 0):
			byte = readByte()
			value = value & 0x00000000_00003FFF | byte << 14
			if (byte < 0):
				byte = readByte()
				value = value & 0x00000000_001FFFFF | byte << 21
				if (byte < 0):
					byte = readByte()
					value = value & 0x00000000_0FFFFFFF | byte << 28
					if (byte < 0):
						byte = readByte()
						value = value & 0x00000007_FFFFFFFF | byte << 35
						if (byte < 0):
							byte = readByte()
							value = value & 0x000003FF_FFFFFFFF | byte << 42
							if (byte < 0):
								byte = readByte()
								value = value & 0x0001FFFF_FFFFFFFF | byte << 49
								if (byte < 0):
									byte = readByte()
									value = value & 0x00FFFFFF_FFFFFFFF | byte << 56
	var mask = value >> 1
	if (mask < 0):
		mask = mask & 0x7FFFFFFF_FFFFFFFF
	return mask ^ -(value & 1)


func writeFloat(value: float):
	buffer.seek(writeOffset)
	buffer.put_float(value)
	writeOffset += 4
	pass

func readFloat() -> float:
	buffer.seek(readOffset)
	var value = buffer.get_float()
	readOffset += 4
	return value

func writeDouble(value: float):
	buffer.seek(writeOffset)
	buffer.put_double(value)
	writeOffset += 8
	pass

func readDouble() -> float:
	buffer.seek(readOffset)
	var value = buffer.get_double()
	readOffset += 8
	return value


func writeString(value: String):
	if (value == null || value.length() ==0):
		writeInt(0)
		return
	buffer.seek(writeOffset)

	var strBytes: PackedByteArray = value.to_utf8_buffer()
	var length: int = strBytes.size()
	writeInt(length)
	buffer.put_partial_data(strBytes)
	writeOffset += length
	pass

func readString() -> String:
	var length: int = readInt()
	if (length <= 0):
		return EMPTY
	buffer.seek(readOffset)
	var value: String = buffer.get_utf8_string(length)
	readOffset += length
	return value

func writePacket(packet, protocolId):
	var protocolRegistration = ProtocolManager.getProtocol(protocolId)
	protocolRegistration.write(self, packet)
	pass

func readPacket(protocolId) -> Object:
	var protocolRegistration = ProtocolManager.getProtocol(protocolId)
	return protocolRegistration.read(self)

func writeBoolArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeBool(element)
	pass

func readBoolArray() -> Array[bool]:
	var array: Array[bool] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readBool())
	return array

func writeByteArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeByte(element)
	pass

func readByteArray() -> Array[int]:
	var array: Array[int] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readByte())
	return array

func writeShortArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeShort(element)
	pass

func readShortArray() -> Array[int]:
	var array: Array[int] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readShort())
	return array

func writeIntArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeInt(element)
	pass

func readIntArray() -> Array[int]:
	var array: Array[int] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readInt())
	return array

func writeLongArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeLong(element)
	pass

func readLongArray() -> Array[int]:
	var array: Array[int] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readLong())
	return array

func writeFloatArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeFloat(element)
	pass

func readFloatArray() -> Array[float]:
	var array: Array[float] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readFloat())
	return array

func writeDoubleArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeDouble(element)
	pass

func readDoubleArray() -> Array[float]:
	var array: Array[float] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readDouble())
	return array

func writeStringArray(array):
	if (array == null):
		writeInt(0)
	else:
		writeInt(array.size())
		for element in array:
			writeString(element)
	pass

func readStringArray() -> Array[String]:
	var array: Array[String] = []
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(readString())
	return array

func writePacketArray(array, protocolId):
	if (array == null):
		writeInt(0)
	else:
		var protocolRegistration = ProtocolManager.getProtocol(protocolId)
		writeInt(array.size())
		for element in array:
			protocolRegistration.write(self, element)
	pass

func readPacketArray(protocolId) -> Array:
	var protocolRegistration = ProtocolManager.getProtocol(protocolId)
	var protocol = ProtocolManager.getProtocolClass(protocolId)
	var array = Array([], typeof(protocol), StringName("RefCounted"), protocol)
	var size = readInt()
	if (size > 0):
		for index in range(size):
			array.append(protocolRegistration.read(self))
	#var a = array.get_typed_class_name()
	#var b = array.get_typed_script()
	#var c = array.get_typed_builtin()

	#var typeArray: Array[ObjectA] = []
	#var aa = typeArray.get_typed_class_name()
	#var bb = typeArray.get_typed_script()
	#var cc = typeArray.get_typed_builtin()
	return array

func writeIntIntMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeInt(key)
			writeInt(map[key])
	pass

func readIntIntMap() -> Dictionary[int, int]:
	var map: Dictionary[int, int] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readInt()
			var value = readInt()
			map[key] = value
	return map

func writeIntLongMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeInt(key)
			writeLong(map[key])
	pass

func readIntLongMap() -> Dictionary[int, int]:
	var map: Dictionary[int, int] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readInt()
			var value = readLong()
			map[key] = value
	return map

func writeIntStringMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeInt(key)
			writeString(map[key])
	pass

func readIntStringMap() -> Dictionary[int, String]:
	var map: Dictionary[int, String] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readInt()
			var value = readString()
			map[key] = value
	return map

func writeIntPacketMap(map, protocolId):
	if (map == null):
		writeInt(0)
	else:
		var protocolRegistration = ProtocolManager.getProtocol(protocolId)
		writeInt(map.size())
		for key in map:
			writeInt(key)
			protocolRegistration.write(self, map[key])
	pass

func readIntPacketMap(protocolId) -> Dictionary:
	var protocolRegistration = ProtocolManager.getProtocol(protocolId)
	var protocol = ProtocolManager.getProtocolClass(protocolId)
	var map = Dictionary({}, TYPE_INT, "", null, typeof(protocol), StringName("RefCounted"), protocol)
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readInt()
			var value = protocolRegistration.read(self)
			map[key] = value
	return map

func writeLongIntMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeLong(key)
			writeInt(map[key])
	pass

func readLongIntMap() -> Dictionary[int, int]:
	var map: Dictionary[int, int] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readLong()
			var value = readInt()
			map[key] = value
	return map

func writeLongLongMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeLong(key)
			writeLong(map[key])
	pass

func readLongLongMap() -> Dictionary[int, int]:
	var map: Dictionary[int, int] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readLong()
			var value = readLong()
			map[key] = value
	return map

func writeLongStringMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeLong(key)
			writeString(map[key])
	pass

func readLongStringMap() -> Dictionary[int, String]:
	var map: Dictionary[int, String] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readLong()
			var value = readString()
			map[key] = value
	return map

func writeLongPacketMap(map, protocolId):
	if (map == null):
		writeInt(0)
	else:
		var protocolRegistration = ProtocolManager.getProtocol(protocolId)
		writeInt(map.size())
		for key in map:
			writeLong(key)
			protocolRegistration.write(self, map[key])
	pass

func readLongPacketMap(protocolId) -> Dictionary:
	var protocolRegistration = ProtocolManager.getProtocol(protocolId)
	var protocol = ProtocolManager.getProtocolClass(protocolId)
	var map = Dictionary({}, TYPE_INT, "", null, typeof(protocol), StringName("RefCounted"), protocol)
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readLong()
			var value = protocolRegistration.read(self)
			map[key] = value
	return map

func writeStringIntMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeString(key)
			writeInt(map[key])
	pass

func readStringIntMap() -> Dictionary[String, String]:
	var map: Dictionary[String, String] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readString()
			var value = readInt()
			map[key] = value
	return map

func writeStringLongMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeString(key)
			writeLong(map[key])
	pass

func readStringLongMap() -> Dictionary[String, int]:
	var map: Dictionary[String, int] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readString()
			var value = readLong()
			map[key] = value
	return map

func writeStringStringMap(map):
	if (map == null):
		writeInt(0)
	else:
		writeInt(map.size())
		for key in map:
			writeString(key)
			writeString(map[key])
	pass

func readStringStringMap() -> Dictionary[String, String]:
	var map: Dictionary[String, String] = {}
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readString()
			var value = readString()
			map[key] = value
	return map

func writeStringPacketMap(map, protocolId):
	if (map == null):
		writeInt(0)
	else:
		var protocolRegistration = ProtocolManager.getProtocol(protocolId)
		writeInt(map.size())
		for key in map:
			writeString(key)
			protocolRegistration.write(self, map[key])
	pass

func readStringPacketMap(protocolId) -> Dictionary:
	var protocolRegistration = ProtocolManager.getProtocol(protocolId)
	var protocol = ProtocolManager.getProtocolClass(protocolId)
	var map = Dictionary({}, TYPE_STRING, "", null, typeof(protocol), StringName("RefCounted"), protocol)
	var size = readInt()
	if (size > 0):
		for index in range(size):
			var key = readString()
			var value = protocolRegistration.read(self)
			map[key] = value
	return map
