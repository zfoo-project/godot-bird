extends Node2D


func _ready():
	var a = 100
	print(clamp(90.1, 90, 200))
	$TouchScreenButton.pressed.connect(test)
	pass


func test():
	print("aaaaaaaaaaaaaaaaaaaaaaaaa")
	pass
