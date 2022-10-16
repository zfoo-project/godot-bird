extends Node2D


func _ready():
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	pass


func startGame():
	Main.changeScene("res://scene/Game.tscn")
	pass
