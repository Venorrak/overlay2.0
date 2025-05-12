extends Node
class_name AnimatorController

signal prepareStart
signal mainEffectStart
signal otherStart
signal contentStart
signal chatStart
signal gizmoStart
signal faceStart
signal finishStart

var mainEffectTime : float = 0.0 
var otherPanelTime : float = 3.0
var contentPanelTime : float = 10.0
var chatPanelTime : float = 30.0
var gizmoPanelTime : float = 40.0
var facePanelTime : float = 50.0

var processTimer : Timer = Timer.new()

func _ready() -> void:
	add_child(processTimer)
	processTimer.wait_time = 600
	processTimer.autostart = false
	processTimer.one_shot = true
	set_process(false)
	set_physics_process(false)
	
func prepare() -> void:
	prepareStart.emit()

func start() -> void:
	processTimer.start()
	set_physics_process(true)

func finish() -> void:
	finishStart.emit()

func _physics_process(delta: float) -> void:
	var currentTime : float = processTimer.wait_time - processTimer.time_left
	if abs(currentTime - facePanelTime) < 0.02:
		faceStart.emit()
		set_physics_process(false)
	elif abs(currentTime - gizmoPanelTime) < 0.02:
		gizmoStart.emit()
	elif abs(currentTime - chatPanelTime) < 0.05:
		chatStart.emit()
	elif abs(currentTime - contentPanelTime) < 0.05:
		contentStart.emit()
	elif abs(currentTime - otherPanelTime) < 0.05:
		otherStart.emit()
	elif abs(currentTime - mainEffectTime) < 0.05:
		mainEffectStart.emit()
