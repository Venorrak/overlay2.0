extends VBoxContainer
@export var prepareBtn : Button
@export var startBtn : Button
@export var finishBtn : Button
@export var brbBtn : Button

func _ready() -> void:
	prepareBtn.button_up.connect(AnimatorOperator.prepare)
	startBtn.button_up.connect(AnimatorOperator.start)
	finishBtn.button_up.connect(AnimatorOperator.finish)
	brbBtn.toggled.connect(brbToggle)
	
func brbToggle(b : bool) -> void:
	SignalBus.toggleBrb.emit(b)
	pass
