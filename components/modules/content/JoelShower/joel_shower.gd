extends Node2D

@export var joelScene : PackedScene

func _ready() -> void:
	StreamBus.subscribe("joel.received", JoelWasSaid)

func JoelWasSaid(payload : Dictionary) -> void:
	for i in payload["count"]:
		var newJoel = joelScene.instantiate()
		add_child(newJoel)
