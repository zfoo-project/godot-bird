extends Object

const StringUtils = preload("res://zfoo/StringUtils.gd")

# 以追加的方式写入一个content
static func writeStringToFile(filePath: String, content: String) -> void:
	var file = File.new()
	file.open(filePath, File.WRITE)
	# bread and butter
	file.store_string(content)
	file.close()
	pass
	

# 读取文件
static func readFileToString(filePath: String) -> String:
	var file = File.new()
	# make sure our file exists on users system
	if !file.file_exists(filePath):
		return StringUtils.EMPTY
	
	# allow reading only for file
	file.open(filePath, File.READ)
	
	var content = file.get_as_text()
	file.close()
	return content

# 读取文件
static func readFileToByteArray(filePath: String) -> PackedByteArray:
	var file = File.new()
	# make sure our file exists on users system
	if !file.file_exists(filePath):
		return PackedByteArray()
	
	# allow reading only for file
	file.open(filePath, File.READ)
	
	var buffer = file.get_buffer(file.get_len())
	file.close()
	return buffer
