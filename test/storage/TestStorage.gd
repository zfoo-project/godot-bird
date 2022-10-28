extends Node2D

const FileUtils = preload("res://zfoo/FileUtils.gd")
const ProtocolManager = preload("res://test/storage/protocol/ProtocolManager.gd")
const ByteBuffer =preload("res://test/storage/protocol/ByteBuffer.gd")

func _ready():
	#jsonReaderTest()
	#csvReaderTest()
	binaryReaderTest()
	pass


func jsonReaderTest():
	var jsonStr: String = FileUtils.readFileToString("res://test/storage/StudentResource.json")
	var obj = JSON.parse_string(jsonStr)
	for header in obj.headers:
		print(header)
	for row in obj.rows:
		print(row)
	var row0 = obj.rows[0]
	print(row0[0])
	print(row0[1])
	print(typeof(row0[0]))
	pass

func csvReaderTest():
	var file = FileAccess.open("res://test/storage/StudentResource.csv.txt", FileAccess.READ)
	while !file.eof_reached():
		var strArray: PackedStringArray = file.get_csv_line()
		print(strArray)
	pass

func binaryReaderTest():
	var buffer = ByteBuffer.new()
	var poolByteArray = FileUtils.readFileToByteArray("res://test/storage/binary_data.cfg")
	buffer.writePackedByteArray(poolByteArray)
	
	var packet = ProtocolManager.read(buffer)
	print(packet)
	pass
