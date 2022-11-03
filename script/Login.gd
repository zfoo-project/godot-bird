extends Node2D

const RandomUtils = preload("res://zfoo/RandomUtils.gd")

func _ready():
	$Timer.timeout.connect(onTimeout)
	pass


func _process(delta):
	pass


func onTimeout():
	var bird = preload("res://scene/effect/EffectFlyBird.tscn").instantiate()
	var createPositionY = randf_range(5, 500)
	bird.position.x = -100
	bird.position.y = createPositionY
	bird.get_node("Bird").animation = RandomUtils.randomEle(Main.birdAnimations)
	bird.speed = RandomUtils.randomIntRange(50, 500)
	add_child(bird)
	pass
