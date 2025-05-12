extends Node3D

@export var d1 : Node3D
@export var d2 : Node3D

var joelCount : int = 0

func _ready() -> void:
	d1.number = 0
	d2.number = 0
	StreamBus.subscribe("joel.received", JoelWasSaid)

func JoelWasSaid(payload : Dictionary) -> void:
	joelCount += payload["count"]
	_refreshDisplay()

func _refreshDisplay() -> void:
	d1.number = joelCount / 10
	d2.number = joelCount % 10
