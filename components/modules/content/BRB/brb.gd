extends Node2D

func _ready() -> void:
	SignalBus.toggleBrb.connect(toggleBRB)
	
func toggleBRB(val : bool) -> void:
	visible = val
