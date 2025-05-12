extends VBoxContainer
@export var prepareBtn : Button
@export var startBtn : Button
@export var finishBtn : Button

func _ready() -> void:
	prepareBtn.button_up.connect(AnimatorOperator.prepare)
	startBtn.button_up.connect(AnimatorOperator.start)
	finishBtn.button_up.connect(AnimatorOperator.finish)
