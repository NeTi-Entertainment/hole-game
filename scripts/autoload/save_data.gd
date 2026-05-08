extends Node

const SAVE_FILE_PATH: String = "user://save_data.json"
const REWARDED_AD_BASE_GOLD: int = 10

var gold: int = 0
var rewarded_ad_watch_count: int = 0


func _ready() -> void:
	load_data()


func load_data() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		save_data()
		return

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Impossible d'ouvrir la sauvegarde : " + SAVE_FILE_PATH)
		return

	var raw_content := file.get_as_text()
	var parsed_data = JSON.parse_string(raw_content)

	if typeof(parsed_data) != TYPE_DICTIONARY:
		push_error("Sauvegarde invalide. Une nouvelle sauvegarde sera créée.")
		save_data()
		return

	gold = int(parsed_data.get("gold", 0))
	rewarded_ad_watch_count = int(parsed_data.get("rewarded_ad_watch_count", 0))


func save_data() -> void:
	var data := {
		"gold": gold,
		"rewarded_ad_watch_count": rewarded_ad_watch_count
	}

	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Impossible d'écrire la sauvegarde : " + SAVE_FILE_PATH)
		return

	file.store_string(JSON.stringify(data, "\t"))


func get_rewarded_ad_gold_amount() -> int:
	return REWARDED_AD_BASE_GOLD + rewarded_ad_watch_count


func claim_rewarded_ad_reward() -> int:
	var reward_amount := get_rewarded_ad_gold_amount()

	gold += reward_amount
	rewarded_ad_watch_count += 1

	save_data()

	return reward_amount
