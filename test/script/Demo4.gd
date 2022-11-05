extends Node2D

const ProtocolManager = preload("res://protocol/ProtocolManager.gd")
const ByteBuffer =preload("res://protocol/ByteBuffer.gd")
const ScoreRankRequest =preload("res://protocol/protocol/cache/ScoreRankRequest.gd")
const ScoreRankResponse =preload("res://protocol/protocol/cache/ScoreRankResponse.gd")

var client = StreamPeerTCP.new()

func _ready():
	#tcpClientTest1()
	tcpClientTest2()
	pass


func _process(delta):
	if (client.get_available_bytes() > 0):
		var length = client.get_32()
		print(length)
		var data = client.get_data(length)
		print(data)
		var buffer = ByteBuffer.new()
		buffer.writePackedByteArray(PackedByteArray(data[1]))
		var packet: ScoreRankResponse = ProtocolManager.read(buffer)
		print(packet)
	pass
	

func tcpClientTest1():
	var result = client.connect_to_host("127.0.0.1", 16000)
	print(result)
	client.poll()
	print(client.get_status())
	client.put_string("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	pass

func tcpClientTest2():
	var result = client.connect_to_host("127.0.0.1", 16000)
	client.big_endian = true
	print(result)
	client.poll()
	print(client.get_status())
	var buffer = ByteBuffer.new()
	buffer.writeRawInt(0)
	ProtocolManager.write(buffer, ScoreRankRequest.new())
	
	var writeOffset = buffer.getWriteOffset();
	buffer.setWriteOffset(0)
	buffer.writeRawInt(writeOffset - 4)
	buffer.setWriteOffset(writeOffset)
	
	var data = buffer.toPackedByteArray()
	client.put_data(data)
	pass
	

func tcpServerTest():
	var server = TCPServer.new()
	server.listen(9000, "127.0.0.1")
	pass
