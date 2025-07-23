extends Node2D
@export var titleLabel : RichTextLabel
@export var artistLabel : RichTextLabel

func _ready() -> void:
	StreamBus.subscribe("spotify.song.start", musicStart)

func musicStart(payload : Dictionary) -> void:
	titleLabel.text = payload["title"]
	artistLabel.text = payload["artist"]
