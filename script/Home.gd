extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")

var titleBirdAnimations: Array[String] = ["bird-blue", "bird-yellow", "bird-red"]

func _ready():
	$UI/Bird.play(RandomUtils.randomEle(titleBirdAnimations))
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	# 每次到home场景都随机一个背景
	Main.randomBackground()
	$Background/Background.texture = Main.currentBackground
	pass


func startGame():
	Main.changeScene(Main.SCENE.Game)
	pass
