extends Node2D

var poller : WindowPoller
@export var windowScene : PackedScene

var windows : Array = []
var acceptedWindows : Array = []

var nameExeptions : Array = []

func _ready() -> void:
	fetchWindowWhiteList()
	SignalBus.fetchWindowList.connect(fetchWindowWhiteList)
	

func fetchWindowWhiteList() -> void:
	var json = JSON.new()
	var json_string = FileAccess.get_file_as_string("res://components/modules/content/capture/windowList.json")
	var error = json.parse(json_string)
	if error == OK:
		var data = json.data
		acceptedWindows = data["whiteList"]
		nameExeptions = data["blackList"]
	
	for win in windows:
			win.shutDown()
			windows.erase(win)
	
	if poller:
		poller.queue_free()
	poller = WindowPoller.new()
	add_child(poller)
	poller.focus_change.connect(focusChange)
	poller.window_closed.connect(windowClosed)
	poller.window_opened.connect(windowOpened)

func focusChange(hwnd : int) -> void:
	var windowName : String = getWindowExeName(hwnd)
	Loggie.info("Window focus switched to : ", windowName)
	if not windowName in acceptedWindows or not getWindowFromHwnd(hwnd) : return
	for win in windows:
		if win.hwnd != hwnd:
			win.visible = false
		else:
			win.visible = true

func windowClosed(hwnd : int) -> void:
	for win in windows:
		if win.hwnd == hwnd:
			win.shutDown()
			windows.erase(win)

func windowOpened(hwnd : int, title : String, class_type: String) -> void:
	Loggie.info("started streaming: [" + title + "][" + getWindowExeName(hwnd) + "]")
	var windowName = getWindowExeName(hwnd) as String
	if windowName in acceptedWindows and not title.to_lower() in nameExeptions: 
		var newWindow = windowScene.instantiate()
		newWindow.hwnd = hwnd
		newWindow.title = title
		add_child(newWindow)
		windows.append(newWindow)

func getWindowExeName(hwnd : int) -> String:
	var command = '"& {[System.Diagnostics.Process]::GetProcesses() | Where-Object { $_.MainWindowHandle -eq ' + str(hwnd) + ' } | Select-Object -ExpandProperty ProcessName}"'
	var data = []
	OS.execute("powershell", ["-Command", command], data)
	if data[0]:
		return data[0].rstrip(" \n" + PackedByteArray([10, 13]).get_string_from_utf8()).to_lower()
	return ""

func getWindowFromHwnd(hwnd : int):
	for win in windows:
		if win.hwnd == hwnd:
			return win
	return null
