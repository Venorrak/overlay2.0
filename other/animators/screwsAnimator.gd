extends Node3D

signal panelCanMove(canMove : bool)

@export_exp_easing var screwing_speed = 5.09
@export_exp_easing var uppies_speed = -2.92
@export var targetMovement: float = 0.45
@export var targetRotation: float = 720
@export var screwingTime : float = 1.5
@export var uppiesTime : float = 3
@export var ejectPower : float = 3

var screws : Array = []
#{
	#obj: screwNode,
	#initialPostition: Vector3,
	#initialRotation: Vector3
#}

enum {SCREWED_IN, SCREWING_OUT, FALLING, UPPIES, SCREWING_IN}
var animState : int = SCREWED_IN
var lastState : int = SCREWED_IN
var processTimer : Timer = Timer.new()

func _ready() -> void:
	for screw in get_children():
		if not screw.is_class("RigidBody3D"): continue
		screws.append({
			"obj": screw,
			"initialPosition": screw.position,
			"initialRotation": screw.rotation_degrees
		})
	SignalBus.toggleEditPanel.connect(toggleAnim)
	processTimer.one_shot = true
	processTimer.ignore_time_scale = true
	add_child(processTimer)

func toggleAnim(enabled : bool) -> void:
	match animState:
		SCREWED_IN:
			if enabled:
				animState = SCREWING_OUT
		SCREWING_OUT:
			if not enabled:
				animState = SCREWING_IN
		FALLING:
			if not enabled:
				animState = UPPIES
		UPPIES:
			if enabled:
				animState = FALLING
		SCREWED_IN:
			if enabled:
				animState = SCREWING_OUT

func _physics_process(delta: float) -> void:
	match animState:
		SCREWED_IN:
			pass
		SCREWING_OUT:
			screwingOut()
		FALLING:
			falling()
		UPPIES:
			uppies()
		SCREWING_IN:
			screwingIn()
	lastState = animState

func isStartingState() -> bool:
	return animState != lastState

func processTimeNormalized() -> float:
	return (processTimer.wait_time - processTimer.time_left) / processTimer.wait_time

func screwingOut() -> void:
	if isStartingState():
		processTimer.wait_time = screwingTime
		processTimer.start()
	for sc in screws:
		sc["obj"].position.z = lerp(sc["initialPosition"].z, sc["initialPosition"].z + targetMovement, ease(processTimeNormalized(), screwing_speed))
		sc["obj"].rotation_degrees.z = lerp(sc["initialRotation"].z, sc["initialRotation"].z + targetRotation, ease(processTimeNormalized(), screwing_speed)) 
	if processTimer.time_left == 0:
		animState = FALLING
		falling()
	
func falling() -> void:
	if isStartingState():
		panelCanMove.emit(true)
		for sc in screws:
			sc["obj"].freeze = false
			sc["obj"].angular_velocity = Vector3(randf_range(-ejectPower, ejectPower), randf_range(-ejectPower, ejectPower), randf_range(-ejectPower, ejectPower))
			sc["obj"].apply_impulse(Vector3(randf_range(-ejectPower / 3, ejectPower / 3), 0, randf_range(0, ejectPower)))
	for sc in screws:
		if not sc["obj"].freeze:
			if sc["obj"].position.y < -11.5:
				sc["obj"].freeze = true
	
func uppies() -> void:
	if isStartingState():
		panelCanMove.emit(false)
		processTimer.wait_time = uppiesTime
		processTimer.start()
		for sc in screws:
			sc["obj"].freeze = true
			sc["obj"].apply_force(Vector3(0, 0, 0))
			sc["obj"].apply_torque(Vector3(0, 0, 0))
			sc["uppiesStartPosition"] = sc["obj"].position
			sc["uppiesStartRotation"] = sc["obj"].rotation_degrees
	for sc in screws:
		sc["obj"].position.x = lerp(sc["uppiesStartPosition"].x, sc["initialPosition"].x, ease(processTimeNormalized(), uppies_speed))
		sc["obj"].position.y = lerp(sc["uppiesStartPosition"].y, sc["initialPosition"].y, ease(processTimeNormalized(), uppies_speed))
		sc["obj"].position.z = lerp(sc["uppiesStartPosition"].z, sc["initialPosition"].z + targetMovement, ease(processTimeNormalized(), uppies_speed))
		sc["obj"].rotation_degrees.x = lerp(sc["uppiesStartRotation"].x, sc["initialRotation"].x, ease(processTimeNormalized(), uppies_speed))
		sc["obj"].rotation_degrees.y = lerp(sc["uppiesStartRotation"].y, sc["initialRotation"].y, ease(processTimeNormalized(), uppies_speed))
		sc["obj"].rotation_degrees.z = lerp(sc["uppiesStartRotation"].z, sc["initialRotation"].z + targetRotation, ease(processTimeNormalized(), uppies_speed))
	if processTimer.time_left == 0:
		animState = SCREWING_IN
		screwingIn()
	
func screwingIn() -> void:
	if isStartingState():
		processTimer.wait_time = screwingTime
		processTimer.start()
	for sc in screws:
		sc["obj"].position.z = lerp(sc["initialPosition"].z + targetMovement, sc["initialPosition"].z, ease(processTimeNormalized(), screwing_speed))
		sc["obj"].rotation_degrees.z = lerp(sc["initialRotation"].z + targetRotation, sc["initialRotation"].z, ease(processTimeNormalized(), screwing_speed))
	if processTimer.time_left == 0:
		animState = SCREWED_IN
