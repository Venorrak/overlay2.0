extends Node2D
@export var messageScene : PackedScene
@export var list : VBoxContainer

func _ready() -> void:
	ChatHandler.newMessage.connect(handleNewMessage)

func handleNewMessage(payload : Dictionary) -> void:
	var newMessage = messageScene.instantiate()
	newMessage.setContent(payload)
	list.add_child(newMessage)
	list.move_child(newMessage, 0)
	if list.get_child_count() > 11:
		list.get_child(11).queue_free()
