extends Node3D

@export var led : SpriteMeshInstance
@export var offMaterial : Material
@export var onMaterial : Material
@export var enabled : bool = true

var on : bool = false :
	set(value):
		on = value
		_updateIntensity()

func _updateIntensity() -> void:
	if enabled:
		if on:
			led.set_surface_override_material(0, onMaterial)
		else:
			led.set_surface_override_material(0, offMaterial)
	else:
		led.set_surface_override_material(0, offMaterial)
