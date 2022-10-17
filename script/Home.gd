extends Node2D

func _ready():
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	# 每次到home场景都随机一个背景
	Main.randomBackground()
	$Background/Background.texture = Main.currentBackground
	$UI/Bird.animation = Main.currentAnimation
	pass


func startGame():
	Main.changeScene(Main.SCENE.Game)
	pass
