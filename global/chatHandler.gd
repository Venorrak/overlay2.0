extends Node

signal newMessage(payload: Dictionary)

var chatted : Array[String] = [] # chatters that chatted
var CommandsRef : Dictionary = {
	"!commands": sendCommandsToChat,
	"!command": sendCommandsToChat,
	"!c": sendCommandsToChat,
	"!discord": sendDiscordToChat,
	
	#"!emotes": sendEmoteList,
	#"!guy": createGuy,
}

func _ready() -> void:
	StreamBus.subscribe("twitch.message", handleMessage)
	
func handleMessage(payload : Dictionary) -> void:
	if payload["name"] not in chatted:
		firstMessage(payload)
	if treatCommands(payload): return
	if payload["name"] == "Venorrak" && payload["raw_message"].left(3) == "[📺]": return
	newMessage.emit(payload)

func treatCommands(data : Dictionary) -> bool:
	var words : PackedStringArray = data["raw_message"].split(" ")
	for command in CommandsRef.keys():
		if command == words[0].to_lower():
			CommandsRef[command].call(words, data)
			return true
	return false

func firstMessage(payload : Dictionary) -> void:
	chatted.append(payload["name"])

func sendCommandsToChat(words : PackedStringArray, payload: Dictionary) -> void:
	var data : Dictionary = {
		"action": "sendMessage",
		"content": "!discord, !song, !JoelCommands"
	}
	StreamBus.sendMessageToBus.emit(data)

func sendDiscordToChat(words: PackedStringArray, payload: Dictionary) -> void:
	var data : Dictionary = {
		"action": "sendMessage",
		"content": "You can see me talking on prod's discord server: https://discord.gg/JzPgeMp3EV or on Jake's discord server: https://discord.gg/MRjMmxQ6Wb"
	}
	StreamBus.sendMessageToBus.emit(data)
