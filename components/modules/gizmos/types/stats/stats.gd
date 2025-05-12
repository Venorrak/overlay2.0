extends Node2D

@export var fpsLabel: Label
@export var ramLabel: Label
@export var nodesLabel: Label
@export var vramLabel: Label

func _on_timer_timeout() -> void:
	fpsLabel.text = str(int(Performance.get_monitor(Performance.TIME_FPS)))
	ramLabel.text = str(Performance.get_monitor(Performance.MEMORY_STATIC) / 1000000000.0)
	nodesLabel.text = str(int(Performance.get_monitor(Performance.OBJECT_COUNT)))
	vramLabel.text = str(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1000000000.0)
