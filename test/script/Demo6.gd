extends Node2D


const WebsocketClient = preload("res://script/WebsocketClient.gd")
const ScoreRankRequest =preload("res://protocol/protocol/cache/ScoreRankRequest.gd")

var websocketClient = WebsocketClient.new("ws://127.0.0.1:18000/websocket")

func _ready():
	websocketClient.start()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var packet = websocketClient.popReceivePacket()
	if (packet != null):
		print("receive packet ..........................")
		print(packet)
	pass


func _on_timer_timeout():
	print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
	websocketClient.send(ScoreRankRequest.new())
	pass
