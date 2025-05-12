extends Node2D
@export var scroll : ScrollContainer
@export var list : VBoxContainer
@export var processTimer : Timer

var entries : Array

var tempEntries : Array = []

func _ready() -> void:
	processTimer.timeout.connect(newEntry)
	var json = JSON.new()
	var json_string = FileAccess.get_file_as_string("res://components/modules/content/startupConsole/entries.json")
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		entries = data_received

func firstEntry() -> void:
	createConsoleEntry("Venorrak@overlay2.0 : ~ $ overlay start")
	
func startContinuousEntries() -> void:
	newEntry()
	processTimer.start()
	
func stopContinuous() -> void:
	processTimer.stop()
	
func newEntry() -> void:
	if tempEntries.size() == 0:
		tempEntries = entries.duplicate()
		tempEntries.shuffle()
	createConsoleEntry(tempEntries.pop_front())

func clearEnties() -> void:
	for lbl in list.get_children():
		lbl.queue_free()

func createConsoleEntry(text: String) -> void:
	var newLabel = RichTextAnimation.new()
	newLabel.animation = "wfc"
	newLabel.play_speed = 20.0
	newLabel.bbcode = text
	newLabel.alignment = HORIZONTAL_ALIGNMENT_LEFT
	newLabel.font_size = 34
	newLabel.color = Color(0.347, 0.529, 0.99)
	newLabel.autostyle_numbers = false
	list.add_child(newLabel)
	scroll.set_deferred("scroll_vertical", scroll.get_v_scroll_bar().max_value)
