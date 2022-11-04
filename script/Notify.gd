extends Node2D

const StringUtils = preload("res://zfoo/StringUtils.gd")

var speed: float = 50
var message: String = StringUtils.EMPTY

@onready var timer: Timer = $Timer

func _ready():
	timer.timeout.connect(onTimeout)
	$Label.text = message
	pass

func _process(delta):
	position.y = position.y + speed * delta
	pass


func onTimeout():
	queue_free()
	pass
