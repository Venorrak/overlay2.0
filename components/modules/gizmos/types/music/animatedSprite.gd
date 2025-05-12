extends Sprite2D
class_name SpriteSheetAnimSprite

@export var animationTime : float

var timer : Timer = Timer.new()
var frameTime : float = 0

func _ready() -> void:
	timer.wait_time = animationTime
	timer.autostart = true
	add_child(timer)
	frameTime = animationTime / hframes
	
func _physics_process(delta: float) -> void:
	var currentTime = (timer.wait_time - timer.time_left) / timer.wait_time
	frame = int(lerp(0.0, float(hframes), currentTime))
