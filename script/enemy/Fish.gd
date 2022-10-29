extends AnimatableBody2D

const Common = preload("res://script/Common.gd")

var speed: float = Common.speedFish()

func _ready():
	$VisibleOnScreenNotifier2d.screen_exited.connect(onScreenExited)
	pass

func _physics_process(delta):
	position.x = position.x - speed * delta
	pass

func onScreenExited():
	queue_free()
	pass
