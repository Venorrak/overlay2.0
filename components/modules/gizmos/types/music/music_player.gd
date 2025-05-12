extends Node2D
@export var titleLabel : RichTextAnimation
@export var artistLabel : RichTextAnimation

func _ready() -> void:
	StreamBus.subscribe("spotify.song.start", musicStart)

func musicStart(payload : Dictionary) -> void:
	titleLabel.bbcode = payload["title"]
	artistLabel.bbcode = payload["artist"]
