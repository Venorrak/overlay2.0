extends GridContainer

@export var panelSelector : OptionButton
@export var editToggle : CheckButton

func _ready() -> void:
	editToggle.toggled.connect(editToggled)
	
func editToggled(toggled) -> void:
	SignalBus.toggleEditPanel.emit(toggled)

func _on_up_button_up() -> void:
	SignalBus.movePanelTo.emit(panelSelector.selected, Vector2(0, -1))

func _on_left_button_up() -> void:
	SignalBus.movePanelTo.emit(panelSelector.selected, Vector2(-1, 0))

func _on_right_button_up() -> void:
	SignalBus.movePanelTo.emit(panelSelector.selected, Vector2(1, 0))
	
func _on_down_button_up() -> void:
	SignalBus.movePanelTo.emit(panelSelector.selected, Vector2(0, 1))
