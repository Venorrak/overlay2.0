extends Node3D

@export var h1 : Node3D
@export var h2 : Node3D

@export var m1 : Node3D
@export var m2 : Node3D

func _on_timer_timeout() -> void:
	var myTime = Time.get_datetime_dict_from_system()
	setHour(myTime["hour"])
	setMinute(myTime["minute"])

func setHour(hour : int) -> void:
	h1.number = hour / 10
	h2.number = hour % 10
	
func setMinute(minute : int) -> void:
	m1.number = minute / 10
	m2.number = minute % 10
