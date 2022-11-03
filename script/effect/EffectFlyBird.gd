extends Node2D


var speed: float = 100

func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(onScreenExited)
	pass

func _physics_process(delta):
	position.x = position.x + speed * delta
	pass

func onScreenExited():
	queue_free()
	pass
