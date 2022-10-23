extends Node2D


func _ready():
	$TouchScreenButton.pressed.connect(test)
	pass


func test():
	print("aaaaaaaaaaaaaaaaaaaaaaaaa")
	pass
