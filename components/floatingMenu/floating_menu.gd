extends Window

signal toggleEditPanel(toggled_on: bool)

@export_group("Panels")
@export var panel : PanelContainer
@export var panelSelector : OptionButton
@export var panelGrid : GridContainer

func _ready() -> void:
	_on_panel_container_resized()

func setPanels(pck : Array) -> void:
	for pan in pck:
		panelSelector.add_item(pan["name"], pan["id"])

func _on_panel_container_resized() -> void:
	size = panel.size
