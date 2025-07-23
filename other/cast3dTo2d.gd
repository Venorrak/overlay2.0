extends Resource
class_name cast3dTo2d

@export var shape : PackedVector2Array = []
var shape3d : PackedVector3Array = []
var lastShape3d : PackedVector3Array = []
var smooth : bool = false
var smoothSpeed : float = 0.4

func _init(_shape : PackedVector2Array = [], _smooth : bool = false) -> void:
	shape = _shape
	smooth = _smooth
	reset()

func reset() -> void:
	lastShape3d = shape3d.duplicate()
	shape3d = []
	for point2d in shape:
		shape3d.append(Vector3(point2d.x, point2d.y, 0))
	if lastShape3d.size() == 0:
		lastShape3d = shape3d.duplicate()
	
func offset(offset: Vector2, point3d: Vector3) -> Vector3:
	return point3d + Vector3(offset.x, offset.y, 0)

func rotate(rotation: Vector3, point3d: Vector3) -> Vector3:
	point3d = point3d.rotated(Vector3(0, 1, 0), rotation.x)
	point3d = point3d.rotated(Vector3(1, 0, 0), rotation.y)
	point3d = point3d.rotated(Vector3(0, 0, 1), rotation.z)
	return point3d
		
func scale(scalingFactor: Vector2, point3d: Vector3) -> Vector3:
	return point3d * Vector3(scalingFactor.x, scalingFactor.y, 0)

func smoothMovement(point3d: Vector3, index: int) -> Vector3:
	return lastShape3d[index].lerp(point3d, smoothSpeed)

func faceStrap(toPosition: Vector2, rotation: Vector3, toCenter: Vector2, scaleFactor: Vector2 = Vector2.ZERO) -> void:
	for index in shape3d.size():
		var point3d : Vector3 = shape3d[index]
		if scaleFactor != Vector2.ZERO:
			point3d = scale(scaleFactor, point3d)
		point3d = offset(toPosition, point3d)
		point3d = rotate(rotation, point3d)
		point3d = offset(toCenter, point3d)
		if smooth:
			point3d = smoothMovement(point3d, index)
		shape3d.set(index, point3d)

func getCast(isReset: bool = false) -> PackedVector2Array:
	var cast : PackedVector2Array = []
	for point3d in shape3d:
		cast.append(Vector2(point3d.x, point3d.y))
	if isReset:
		reset()
	return cast
