extends Node2D
@export var title : RichTextLabel
@export var message : RichTextLabel
@export var timer : Timer

func _ready() -> void:
	StreamBus.subscribe("twitch.raid", onRaid)
	
func onRaid(payload: Dictionary) -> void:
	modulate = Color(1, 1, 1, 1)
	message.text = payload["name"] + " invaded the broadcast with " + str(int(payload["count"])) + " entities!"
	timer.start()
	
func _on_timer_timeout() -> void:
	modulate = Color(1, 1, 1, 0)
