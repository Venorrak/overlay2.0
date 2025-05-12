extends Node3D

@export var minElevation : float
@export var elevationSpread : float
@export var elevationTime : float
@export var cameraUnzoom : Vector2
@export_exp_easing var elevationSpeed
@export var panelMovementTime : float
@export_exp_easing var panelMovementSpeed
@export_group("positioning")
@export var yAnchors : Array[float]
@export var xAnchors : Array[float]

@export var camera : Camera3D

enum {PANELS_MOVING_UP, MOVABLE, MOVING, PANELS_MOVING_DOWN, IDLE_DOWN}
var currentState : int = IDLE_DOWN
var lastState : int = IDLE_DOWN
var panels : Array = []
var processTimer : Timer = Timer.new()

var movingPanel : Module
var movingTranslate : Vector2

func _ready() -> void:
	for panel in get_children():
		if panel.is_class("Node3D"):
			panels.append(panel)
			panel.get_node("Screws").panelCanMove.connect(_setCanMovePanel)
	processTimer.one_shot = true
	processTimer.ignore_time_scale = true
	add_child(processTimer)
	sendPanelsToMenu()
	SignalBus.movePanelTo.connect(handlePanelMovementCommand)

func handlePanelMovementCommand(panelId: int, movement: Vector2) -> void:
	if not currentState == MOVABLE: return
	movingPanel = get_child(panelId)
	if movement.x + movingPanel.GridPos.x > 18 || movement.x + movingPanel.GridPos.x < 0: return
	if movement.y + movingPanel.GridPos.y > 6 || movement.y + movingPanel.GridPos.y < 0: return
	currentState = MOVING
	movingTranslate = movement

func sendPanelsToMenu() -> void:
	var pck : Array = []
	for i in panels.size():
		pck.append({
			"id": i,
			"name": panels[i].name
		})
	FloatingMenu.setPanels(pck)

func _setCanMovePanel(canMove : bool) -> void:
	if currentState == MOVING: return
	if canMove:
		currentState = PANELS_MOVING_UP
		_panelsMovingUp()
	else:
		currentState = PANELS_MOVING_DOWN
		_panelsMovingDown()

func isStartingState() -> bool:
	return currentState != lastState

func processTimeNormalized() -> float:
	return (processTimer.wait_time - processTimer.time_left) / processTimer.wait_time

func _physics_process(delta: float) -> void:
	match  currentState:
		PANELS_MOVING_UP:
			_panelsMovingUp()
		MOVABLE:
			pass
		PANELS_MOVING_DOWN:
			_panelsMovingDown()
		IDLE_DOWN:
			pass
		MOVING:
			_panelMoving()
	lastState = currentState

func _panelsMovingUp() -> void:
	if isStartingState():
		processTimer.wait_time = elevationTime
		processTimer.start()
		panels.shuffle()
	for i in panels.size():
		panels[i].position.z = lerp(0.0, minElevation + (i * elevationSpread), ease(processTimeNormalized(), elevationSpeed))
		camera.position.z = lerp(cameraUnzoom.x, cameraUnzoom.y, ease(processTimeNormalized(), elevationSpeed))
	if processTimer.time_left == 0:
		currentState = MOVABLE

func _panelsMovingDown() -> void:
	if isStartingState():
		processTimer.wait_time = elevationTime
		processTimer.start()
	for i in panels.size():
		panels[i].position.z = lerp(minElevation + (i * elevationSpread), 0.0, ease(processTimeNormalized(), elevationSpeed))
		camera.position.z = lerp(cameraUnzoom.y, cameraUnzoom.x, ease(processTimeNormalized(), elevationSpeed))
	if processTimer.time_left == 0:
		currentState = IDLE_DOWN

func _panelMoving() -> void:
	if isStartingState():
		processTimer.wait_time = panelMovementTime
		processTimer.start()
		#focusPanel(movingPanel)
	movingPanel.position.x = lerp(xAnchors[movingPanel.GridPos.x], xAnchors[movingPanel.GridPos.x + int(movingTranslate.x)], ease(processTimeNormalized(), panelMovementSpeed))
	movingPanel.position.y = lerp(yAnchors[movingPanel.GridPos.y], yAnchors[movingPanel.GridPos.y + int(movingTranslate.y)], ease(processTimeNormalized(), panelMovementSpeed))
	
	if processTimer.time_left == 0:
		#focusPanel()
		movingPanel.GridPos.x += movingTranslate.x
		movingPanel.GridPos.y += movingTranslate.y
		currentState = MOVABLE

func focusPanel(panel : Module = null) -> void:
	for chi in get_children():
		if panel:
			if not panel == chi && chi.is_class("Node3D"):
				chi.visible = false
		else:
			if chi.is_class("Node3D"):
				chi.visible = true
