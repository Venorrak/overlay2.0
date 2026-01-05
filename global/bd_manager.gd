extends Node

var adress : String = "http://192.168.0.152:5001"
var json : JSON = JSON.new()
var requests : Array = []

func request(route : String, params : Array, callback : Signal) -> String:
	var newHTTP = HTTPRequest.new()
	add_child(newHTTP)
	newHTTP.timeout = 10
	newHTTP.request_completed.connect(self._http_request_completed)
	var randomId : String = randWord()
	requests.append({
		"node": newHTTP,
		"id": randomId,
		"callback": callback
	})
	newHTTP.request(adress + route, ["Content-Type: application/json", "Request-Id: " + randomId], HTTPClient.METHOD_POST, json.stringify(params))
	return randomId

func _http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var requestId : String = ""
	var concernedRequest : Dictionary = {}
	for header in headers:
		if header.begins_with("Request-Id"):
			requestId = header.split(": ")[1]
	for request in requests:
		if request["id"] == requestId:
			concernedRequest = request
			
	concernedRequest["node"].queue_free()
	concernedRequest["callback"].emit(result, response_code, headers, json.parse_string(body.get_string_from_utf8()), requestId)

func randWord() -> String:
	var word : String = ""
	var characters : Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
	for i in 8:
		word += characters[randi_range(0, 35)]
	return word
