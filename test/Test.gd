extends Node2D

const TimeUtils = preload("res://zfoo/TimeUtils.gd")
const GodotCommonResource = preload("res://storage/GodotCommonResource.gd")

func _ready():
	print("aaaaaaaaaaaaaaaaaaaaaaaaa")
	print(TimeUtils.currentTimeMillis())
	print(Time.get_datetime_string_from_system())
	print(TimeUtils.timeToString(TimeUtils.currentTimeMillis()))
	
	var a = GodotCommonResource.new()
	print(a.get_script().get_global_name())
	pass
