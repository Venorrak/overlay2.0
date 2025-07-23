extends Node2D
@export var gif : AnimatedSprite2D
@export var fallSpeed : float

func _ready() -> void:
	position.x = randf_range(190, 1730)
	position.y = -30
	gif.play()

func _physics_process(delta: float) -> void:
	position.y += fallSpeed * delta
	if position.y > 1100:
		queue_free()
