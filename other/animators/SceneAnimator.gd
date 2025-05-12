extends AnimationPlayer
class_name SceneAnimator

@export_enum("main", "other", "content", "chat", "gizmo", "face") var type

func _ready() -> void:
	AnimatorOperator.prepareStart.connect(prepare)
	AnimatorOperator.finishStart.connect(finish)
	match type:
		0:
			AnimatorOperator.mainEffectStart.connect(start)
		1:
			AnimatorOperator.otherStart.connect(start)
		2:
			AnimatorOperator.contentStart.connect(start)
		3:
			AnimatorOperator.chatStart.connect(start)
		4:
			AnimatorOperator.gizmoStart.connect(start)
		5:
			AnimatorOperator.faceStart.connect(start)
		
	
func prepare() -> void:
	play("prepare")

func start() -> void:
	play("start")

func finish() -> void:
	play("finish")
