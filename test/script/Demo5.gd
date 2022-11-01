extends Node2D


const TcpClient = preload("res://script/TcpClient.gd")
const ScoreRankRequest =preload("res://protocol/protocol/cache/ScoreRankRequest.gd")

var tcpClient = TcpClient.new("127.0.0.1:16000")

func _ready():
	tcpClient.start()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var packet = tcpClient.popReceivePacket()
	if (packet != null):
		print("receive packet ..........................")
		print(packet)
	pass


func _on_timer_timeout():
	tcpClient.send(ScoreRankRequest.new())
	pass
