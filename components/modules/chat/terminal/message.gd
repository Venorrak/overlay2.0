extends Control

const MESSAGE_SEPARATOR : String = "
---------------------"
@export var label : RichTextAnimation
@export var timer : Timer

@export var baseColor : Color
@export var baseSound : AudioStream

var username : String = " unknown"
var message : String = " "


func setContent(data : Dictionary) -> void:
	username = data["name"]
	message = data["raw_message"]

func _ready() -> void:
	AudioManager.playSound(baseSound, 0.1)
	label.color = baseColor
	label.bbcode = username + ": " + message + MESSAGE_SEPARATOR


func _on_text_anim_finished() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	label.play_speed = 0.0
