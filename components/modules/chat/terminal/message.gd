extends Control

const MESSAGE_SEPARATOR : String = "
---------------------"
@export var label : RichTextLabel

@export var baseColor : Color
@export var baseSound : AudioStream

var username : String = " unknown"
var message : String = " "


func setContent(data : Dictionary) -> void:
	username = data["name"]
	message = data["raw_message"]

func _ready() -> void:
	AudioManager.playSound(baseSound, 0.1)
	label.text = username + ": " + message + MESSAGE_SEPARATOR
