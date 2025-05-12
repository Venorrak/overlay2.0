extends Node3D

@export var http : HTTPRequest
@export var leds : Array[Node3D]

var json : JSON = JSON.new()

func _ready() -> void:
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	http.request("https://server.venorrak.dev/api/joels/JCP/short?limit=1")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var pkt = json.parse_string(body.get_string_from_utf8())
		var jcp : int = int(pkt[0]["JCP"])
		_refreshDisplay(jcp)

func _refreshDisplay(jcp : int) -> void:
	var increment : int = jcp / 10
	for i in leds.size():
		if i <= increment:
			leds[i].on = true
		else:
			leds[i].on = false
			
