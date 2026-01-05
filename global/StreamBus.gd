extends Node

var json : JSON = JSON.new()
var num_socket : int = 5555
var server = WebSocketPeer.new()

signal websocketMessage
signal callBackendCommand(commandName: String, data: Dictionary)

var subscriptions : Dictionary[String, Array] = {}

func _ready() -> void:
	server.connect_to_url("ws://192.168.0.152:5000")
	callBackendCommand.connect(callCommand)
	
func _process(delta: float) -> void:
	server.poll()
	var state = server.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while server.get_available_packet_count():
			var pkt = server.get_packet()
			var data = json.parse_string(str(pkt.get_string_from_utf8()))
			Loggie.debug(data)
			callBindedToSubject(data["subject"], data["payload"])
			websocketMessage.emit(data)
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = server.get_close_code()
		var reason = server.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])

func callCommand(commandName: String, data : Dictionary) -> void:
	server.send_text(JSON.stringify({
		"subject": "command." + commandName,
		"payload": data
	}))

func callBindedToSubject(subject: String, payload: Dictionary) -> void:
	if subscriptions.get(subject) == null: return
	for bind in subscriptions[subject]:
		bind.call(payload)

func subscribe(subject: String, callback: Callable) -> void:
	if subscriptions.get(subject) == null:
		subscriptions.set(subject, [])
	subscriptions[subject].append(callback)
