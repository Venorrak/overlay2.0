extends VBoxContainer
@export var orthoBtn : CheckButton

func _ready() -> void:
	orthoBtn.toggled.connect(orthoBtnToggled)
	
func orthoBtnToggled(bleh) -> void:
	SignalBus.toggleOrtho.emit()
