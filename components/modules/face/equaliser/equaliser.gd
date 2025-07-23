extends Node2D
@export var width : float

@onready
var spectrum = AudioServer.get_bus_effect_instance(1,0)

@onready
var audioPlayer = $AudioStreamPlayer
 
const VU_COUNT = 16
const HEIGHT = 150
const FREQ_MAX = 11050.0
 
const MIN_DB = 60

var wave : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
 
# Called when the node enters the scene tree for the first time.
func _ready():
	audioPlayer.autoplay = true
	audioPlayer.playing = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var prev_hz = 0
	for i in range(1,VU_COUNT+1):   
		var hz = i * FREQ_MAX / VU_COUNT;
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length()))/MIN_DB,0,1)
		var height = energy * HEIGHT
 
		prev_hz = hz
		wave[i-1] = height
 
		#var tween = get_tree().create_tween()
		#tween.tween_property(topRightRect, "size", Vector2(topRightRect.size.x, height), 0.05)
		#tween.tween_property(topLeftRect, "size", Vector2(topLeftRect.size.x, height), 0.05)
		#tween.tween_property(bottomRightRect, "size", Vector2(bottomRightRect.size.x, height), 0.05)
		#tween.tween_property(bottomLeftRect, "size", Vector2(bottomLeftRect.size.x, height), 0.05)

func getShape() -> PackedVector2Array:
	var shape : PackedVector2Array = []
	for index in wave.size():
		shape.append(Vector2(width * index, wave[index]))
		shape.append(Vector2((width * index) + width, wave[index]))
	for index in wave.size():
		var reversedIndex = (wave.size() - index) - 1
		shape.append(Vector2((width * reversedIndex) + width, -wave[reversedIndex] - 3))
		shape.append(Vector2(width * reversedIndex, -wave[reversedIndex] - 3))
	for index in wave.size():
		shape.append(Vector2(width * index * -1, -wave[index] - 3))
		shape.append(Vector2((width * index * -1) - width, -wave[index] - 3))
	for index in wave.size():
		var reversedIndex = (wave.size() - index) - 1
		shape.append(Vector2((width * index) - (VU_COUNT * width), wave[reversedIndex]))
		shape.append(Vector2((width * index) - (VU_COUNT * width) + width, wave[reversedIndex]))
		
	return shape
