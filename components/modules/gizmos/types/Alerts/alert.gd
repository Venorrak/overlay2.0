extends PanelContainer
@export var label : RichTextAnimation
@export var separator : Label

func setContent(title: String, message: String, color: Color = Color(0.306, 0.435, 1.0), sound: AudioStream = null) -> void:
	label.bbcode = title + ": " + message
	label.color = color
	separator.modulate = color
	if sound:
		AudioManager.playSound(sound, 0.3)
