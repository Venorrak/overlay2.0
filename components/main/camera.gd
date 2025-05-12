extends Camera3D

func _ready() -> void:
	SignalBus.toggleOrtho.connect(toggleOrtho)
	
func toggleOrtho() -> void:
	if projection == Camera3D.PROJECTION_PERSPECTIVE:
		projection = Camera3D.PROJECTION_ORTHOGONAL
	else:
		projection = Camera3D.PROJECTION_PERSPECTIVE
