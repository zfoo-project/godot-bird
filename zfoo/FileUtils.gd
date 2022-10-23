extends Object

const StringUtils = preload("res://zfoo/StringUtils.gd")

# 以追加的方式写入一个content
static func writeStringToFile(filePath: String, content: String) -> void:
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	# bread and butter
	file.store_string(content)
	file.close()
	pass
	

# 读取文件
static func readFileToString(filePath: String) -> String:
	# make sure our file exists on users system
	if !FileAccess.file_exists(filePath):
		return StringUtils.EMPTY
	
	# allow reading only for file
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	var content = file.get_as_text()
	file.close()
	return content

# 读取文件
static func readFileToByteArray(filePath: String) -> PackedByteArray:
	# make sure our file exists on users system
	if !FileAccess.file_exists(filePath):
		return PackedByteArray()
	
	# allow reading only for file
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	var buffer = file.get_buffer(file.get_len())
	file.close()
	return buffer
