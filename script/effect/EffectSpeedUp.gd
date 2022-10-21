extends Node2D

signal speedUpSignal(node: Node2D, other)

func _ready():
	$Area2d.connect("body_entered", Callable(self, "onSpeedUpEntered"))
	pass 

func onSpeedUpEntered(other_body):
	emit_signal("speedUpSignal", self, other_body)
	pass
