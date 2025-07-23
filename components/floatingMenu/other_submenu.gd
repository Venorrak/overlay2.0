extends VBoxContainer
@export var orthoBtn : CheckButton
@export var fetchWindowListBtn : Button

func _ready() -> void:
	fetchWindowListBtn.button_up.connect(fetchWindowList)
	orthoBtn.toggled.connect(orthoBtnToggled)
	
func orthoBtnToggled(bleh) -> void:
	SignalBus.toggleOrtho.emit()

func fetchWindowList() -> void:
	SignalBus.fetchWindowList.emit()
