extends Node2D
@export var singleAlertScene : PackedScene
@export var list : VBoxContainer

@export_group("sounds")
@export var followSound : AudioStream
@export var subSound : AudioStream
@export var raidSound : AudioStream
@export var adsSound : AudioStream
@export var cheerSound : AudioStream

@export_group("colors")
@export var followColor : Color
@export var subColor : Color
@export var raidColor : Color
@export var adsColor : Color
@export var cheerColor : Color

func _ready() -> void:
	SignalBus.createAlert.connect(handleNewAlert)
	StreamBus.subscribe("twitch.follow", onFollow)
	StreamBus.subscribe("twitch.sub", onSub)
	StreamBus.subscribe("twitch.sub.gift", onSubGift)
	StreamBus.subscribe("twitch.sub.resub", onSubMessage)
	StreamBus.subscribe("twitch.ads.begin", onAds)
	StreamBus.subscribe("twitch.cheer", onCheer)
	StreamBus.subscribe("twitch.raid", onRaid)

func handleNewAlert(title: String, message: String) -> void:
	var newAlert = singleAlertScene.instantiate()
	newAlert.setContent(title, message)
	addAlertToList(newAlert)

func addAlertToList(alert) -> void:
	list.add_child(alert)
	list.move_child(alert, 0)

func onFollow(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	newAlert.setContent(payload["name"], "has followed", followColor, followSound)
	addAlertToList(newAlert)

func onSub(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	newAlert.setContent(payload["name"], "has subscribe", subColor, subSound)
	addAlertToList(newAlert)
	
func onSubMessage(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	newAlert.setContent(payload["name"], "resubscibed", subColor, subSound)
	addAlertToList(newAlert)
	
func onSubGift(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	var gifter : String = "Anonymous"
	if not payload["anonymous"]:
		gifter = payload["name"]
	newAlert.setContent(gifter, "gifted " + str(payload["count"] + " subs"), subColor, subSound)
	addAlertToList(newAlert)

func onRaid(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	newAlert.setContent(payload["name"], "Raided with " + str(payload["count"]), raidColor, raidSound)
	addAlertToList(newAlert)
	
func onAds(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	newAlert.setContent("Ads", "for " + str(payload["duration"]) + " secons", adsColor, adsSound)
	addAlertToList(newAlert)

func onCheer(payload: Dictionary) -> void:
	var newAlert = singleAlertScene.instantiate()
	var cheerer : String = "Anonymous"
	if not payload["anonymous"]:
		cheerer = payload["name"]
	newAlert.setContent(cheerer, "Cheered " + str(payload["count"]) + " bits", raidColor, raidSound)
	addAlertToList(newAlert)
