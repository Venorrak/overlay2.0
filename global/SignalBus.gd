extends Node

#camera
signal toggleOrtho

#panels
signal movePanelTo(panelId: int, movement: Vector2)
signal toggleEditPanel(toggled_on: bool)

#feed
signal createAlert(title: String, message: String)
