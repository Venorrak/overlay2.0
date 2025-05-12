extends Node3D

@export var offMaterial : Material
@export var onMaterial : Material
@export var segments : Array[SpriteMeshInstance]
@export var enabled : bool = true

var ledNumberRed : Dictionary = {
	0 : [true, true, true, false, true, true, true],
	1 : [false, false, true, false, false, true, false],
	2 : [true, false, true, true, true, false, true],
	3 : [true, false, true, true, false, true, true],
	4 : [false, true, true, true, false, true, false],
	5 : [true, true, false, true, false, true, true],
	6 : [true, true, false, true, true, true, true],
	7 : [true, false, true, false, false, true, false],
	8 : [true, true, true, true, true, true, true],
	9 : [true, true, true, true, false, true, true],
	-1 : [false, false, false, false, false, false, false]
}
var number : int = -1 :
	get:
		return number
	set(value):
		if value < 0:
			number = -1
		elif value > 9:
			number = -1
		else:
			number = value
		refreshDisplay()

func refreshDisplay() -> void:
	if enabled:
		for i in segments.size():
			if ledNumberRed[number][i]:
				segments[i].set_surface_override_material(0, onMaterial)
			else:
				segments[i].set_surface_override_material(0, offMaterial)
	else:
		for i in segments.size():
			segments[i].set_surface_override_material(0, offMaterial)
