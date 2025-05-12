extends Node2D

@export var poller : WindowPoller
@export var windowScene : PackedScene

var windows : Array = []
var acceptedWindows : Array[String] = [
	"godot_v4.4.1-stable_win64",
	"windowsterminal",
	"brave",
	"code"
]

var nameExeptions : Array[String] = [
	"overlay2.0 (debug)",
	"menu"
]

func _ready() -> void:
	poller.focus_change.connect(focusChange)
	poller.window_closed.connect(windowClosed)
	poller.window_opened.connect(windowOpened)

func focusChange(hwnd : int) -> void:
	if not getWindowExeName(hwnd) in acceptedWindows or not getWindowFromHwnd(hwnd) : return
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
