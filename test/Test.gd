extends Node2D

const TimeUtils = preload("res://zfoo/TimeUtils.gd")

func _ready():
	print("aaaaaaaaaaaaaaaaaaaaaaaaa")
	print(TimeUtils.currentTimeMillis())
	print(Time.get_datetime_string_from_system())
	print(TimeUtils.timeToString(TimeUtils.currentTimeMillis()))
	pass



