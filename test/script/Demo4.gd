extends Node2D


var client = StreamPeerTCP.new()

var arr = PackedByteArray()

func _ready():
	var result = client.connect_to_host("127.0.0.1", 9000)
	print(result)
	client.poll()
	print(client.get_status())
	for i in range(10000):
		arr.append(66)

var count = 0

func _process(delta):
	client.put_data(arr)
	pass


func tcpServerTest():
	var server = TCPServer.new()
	server.listen(9000, "127.0.0.1")
	pass
