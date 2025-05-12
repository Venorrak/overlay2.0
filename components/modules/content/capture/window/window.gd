extends Node2D
@onready var display : TextureRect = $display 
@onready var capture : WindowCaptureTexture = $capture

var hwnd : int = 0
var title : String = ""

func _ready() -> void:
	if not hwnd:
		queue_free()
	capture.start_capture(hwnd)

func _physics_process(delta: float) -> void:
	display.texture = capture.get_texture()

func shutDown() -> void:
	capture.stop_capture()
	queue_free()

func _on_display_minimum_size_changed() -> void:
	var scaleToTargetWidth : float = 1920 / display.size.x
	var scaleToTargetHeight : float = 1030 / display.size.y
	# x   max
	# - = ---
	# 1   size
	var newScale : float = 1
	if abs(1 - scaleToTargetWidth) < abs(1 - scaleToTargetHeight):
		newScale = scaleToTargetWidth
	else:
		newScale = scaleToTargetHeight
	#if newScale > 1:
	display.scale = Vector2(newScale, newScale)
