extends Node2D

@export var equaliser : Node2D
@export var color1Eye : Color
@export var color2Eye : Color
@export var color1Mouth : Color
@export var color2Mouth : Color

var leftEye : cast3dTo2d
var leftPupil : cast3dTo2d
var rightEye : cast3dTo2d
var rightPupil : cast3dTo2d
var mouth : cast3dTo2d
var leftEyeOffset : Vector2 = Vector2(-240, -260)
var rightEyeOffset : Vector2 = Vector2(240, -260)
var starStickerOffset : Vector2 = Vector2(220, -140)
var mouthOffset : Vector2 = Vector2(0, 170)
var center : Vector2 = Vector2(640, 530)

var eyeShape : PackedVector2Array = [
	Vector2(0, -66),
	Vector2(22, -58),
	Vector2(36, -40),
	Vector2(43, -21),
	Vector2(46, 1),
	Vector2(42, 26),
	Vector2(34, 45),
	Vector2(21, 60),
	Vector2(0, 67),
	Vector2(-21, 60),
	Vector2(-34, 45),
	Vector2(-42, 26),
	Vector2(-46, 1),
	Vector2(-43, -21),
	Vector2(-36, -40),
	Vector2(-22, -58),
]
var pupilShape : PackedVector2Array = [
	Vector2(0, -42),
	Vector2(10, -35),
	Vector2(16, -21),
	Vector2(19, -1),
	Vector2(16, 20),
	Vector2(10, 34),
	Vector2(0, 41),
	Vector2(-10, 34),
	Vector2(-16, 20),
	Vector2(-19, -1),
	Vector2(-16, -21),
	Vector2(-10, -35),
]
var starShape : PackedVector2Array = [
	Vector2(-2, -26),
	Vector2(7, -2),
	Vector2(28, 6),
	Vector2(8, 9),
	Vector2(14, 26),
	Vector2(-4, 13),
	Vector2(-23, 24),
	Vector2(-13, 10),
	Vector2(-28, 2),
	Vector2(-10, -2),
]

func _ready() -> void:
	leftEye = cast3dTo2d.new(eyeShape, true)
	rightEye = cast3dTo2d.new(eyeShape, true)
	mouth = cast3dTo2d.new([], true)
	leftPupil = cast3dTo2d.new(pupilShape, true)
	rightPupil = cast3dTo2d.new(pupilShape, true)
	$faceSocket.movementPing.connect(updateMovement)

func _draw() -> void:
	draw_colored_polygon(leftEye.getCast(true), Color("4e6fff"))
	draw_colored_polygon(rightEye.getCast(true), Color("4e6fff"))
	draw_colored_polygon(mouth.getCast(true), Color("4e6fff"))
	draw_colored_polygon(leftPupil.getCast(true), Color.BLACK)
	draw_colored_polygon(rightPupil.getCast(true), Color.BLACK)

func updateMovement(landmarks: Array) -> void:
	var left_face_pos = landmarks[0]
	var right_face_pos = landmarks[1]
	var top_face_pos = landmarks[2]
	var bottom_face_pos = landmarks[3]
	
	var top_left_eye_pos = landmarks[4]
	var bottom_left_eye_pos = landmarks[5]
	var iris_left_eye_pos = landmarks[6]
	var left_left_eye_pos = landmarks[7]
	var right_left_eye_pos = landmarks[8]
	
	var top_right_eye_pos = landmarks[9]
	var bottom_right_eye_pos = landmarks[10]
	var iris_right_eye_pos = landmarks[11]
	var left_right_eye_pos = landmarks[12]
	var right_right_eye_pos = landmarks[13]
	
	var faceRotation : Vector3 = Vector3.ZERO
	faceRotation.x = -((left_face_pos[2] - right_face_pos[2]) / 180)
	faceRotation.y = (((top_face_pos[2] - bottom_face_pos[2]) / 150) + 0.5)
	
	var delta_opening_right_eye = sqrt(pow(top_right_eye_pos[0] - bottom_right_eye_pos[0], 2) + pow(top_right_eye_pos[1] - bottom_right_eye_pos[1], 2) + pow(top_right_eye_pos[2] - bottom_right_eye_pos[2], 2))
	var delta_opening_left_eye = sqrt(pow(top_left_eye_pos[0] - bottom_left_eye_pos[0], 2) + pow(top_left_eye_pos[1] - bottom_left_eye_pos[1], 2) + pow(top_left_eye_pos[2] - bottom_left_eye_pos[2], 2))
	
	var left_left_eye_delta = sqrt(pow(left_left_eye_pos[0] - iris_left_eye_pos[0], 2) + pow(left_left_eye_pos[1] - iris_left_eye_pos[1], 2) + pow(left_left_eye_pos[2] - iris_left_eye_pos[2], 2)) 
	var right_left_eye_delta = sqrt(pow(right_left_eye_pos[0] - iris_left_eye_pos[0], 2) + pow(right_left_eye_pos[1] - iris_left_eye_pos[1], 2) + pow(right_left_eye_pos[2] - iris_left_eye_pos[2], 2))
	#var top_left_eye_delta = sqrt(pow(top_left_eye_pos[0] - iris_left_eye_pos[0], 2) + pow(top_left_eye_pos[1] - iris_left_eye_pos[1], 2) + pow(top_left_eye_pos[2] - iris_left_eye_pos[2], 2))
	#var bottom_left_eye_delta = sqrt(pow(bottom_left_eye_pos[0] - iris_left_eye_pos[0], 2) + pow(bottom_left_eye_pos[1] - iris_left_eye_pos[1], 2) + pow(bottom_left_eye_pos[2] - iris_left_eye_pos[2], 2))
	var left_right_eye_delta = sqrt(pow(left_right_eye_pos[0] - iris_right_eye_pos[0], 2) + pow(left_right_eye_pos[1] - iris_right_eye_pos[1], 2) + pow(left_right_eye_pos[2] - iris_right_eye_pos[2], 2))
	var right_right_eye_delta = sqrt(pow(right_right_eye_pos[0] - iris_right_eye_pos[0], 2) + pow(right_right_eye_pos[1] - iris_right_eye_pos[1], 2) + pow(right_right_eye_pos[2] - iris_right_eye_pos[2], 2))
	#var top_right_eye_delta = sqrt(pow(top_right_eye_pos[0] - iris_right_eye_pos[0], 2) + pow(top_right_eye_pos[1] - iris_right_eye_pos[1], 2) + pow(top_right_eye_pos[2] - iris_right_eye_pos[2], 2))
	#var bottom_right_eye_delta = sqrt(pow(bottom_right_eye_pos[0] - iris_right_eye_pos[0], 2) + pow(bottom_right_eye_pos[1] - iris_right_eye_pos[1], 2) + pow(bottom_right_eye_pos[2] - iris_right_eye_pos[2], 2))
	var leftEyeDirection : Vector2 = Vector2.ZERO
	var rightEyeDirection : Vector2 = Vector2.ZERO
	var eyeLateralAmp : float = 5.0
	leftEyeDirection.x = (-left_left_eye_delta + right_left_eye_delta) * eyeLateralAmp
	#leftEyeDirection.y = (-top_left_eye_delta + bottom_left_eye_delta) * 5
	rightEyeDirection.x = (-left_right_eye_delta + right_right_eye_delta) * eyeLateralAmp
	#rightEyeDirection.y = (-top_right_eye_delta + bottom_right_eye_delta) * 5
	var rightPupilDirection : float = ((clamp(rightEyeDirection.x / eyeLateralAmp, -35, 35) / 35) + -faceRotation.x) / 2
	var leftPupilDirection : float = ((clamp(leftEyeDirection.x / eyeLateralAmp, -35, 35) / 35) + -faceRotation.x) / 2
	var closedEyesThreshold : float = 9.0
	mouth.shape = equaliser.getShape()
	leftEye.faceStrap(leftEyeOffset + leftEyeDirection, faceRotation, center, Vector2(1, 0.1) if delta_opening_left_eye < closedEyesThreshold else Vector2(1, 1))
	rightEye.faceStrap(rightEyeOffset + rightEyeDirection, faceRotation, center, Vector2(1, 0.1) if delta_opening_right_eye < closedEyesThreshold else Vector2(1, 1))
	leftPupil.faceStrap(leftEyeOffset + leftEyeDirection + Vector2(lerp(0, 27, leftPupilDirection), lerp(0, 25, -faceRotation.y)), faceRotation, center, Vector2(0.001, 0.001) if delta_opening_left_eye < closedEyesThreshold else Vector2(1, 1))
	rightPupil.faceStrap(rightEyeOffset + rightEyeDirection + Vector2(lerp(0, 27, rightPupilDirection), lerp(0, 25, -faceRotation.y)), faceRotation, center, Vector2(0.001, 0.001) if delta_opening_right_eye < closedEyesThreshold else Vector2(1, 1))
	mouth.faceStrap(mouthOffset, faceRotation, center)
	queue_redraw()
