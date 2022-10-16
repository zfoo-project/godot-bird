extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")

var titleBirdAnimations: Array[String] = ["bird-blue", "bird-yellow", "bird-red"]

func _ready():
	$UI/Bird.play(RandomUtils.randomEle(titleBirdAnimations))
	$Control/Start.connect("pressed", Callable(self, "startGame"))
	pass


func startGame():
	Main.changeScene(Main.SCENE.Game)
	pass
