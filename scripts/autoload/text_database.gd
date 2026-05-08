extends Node

const TEXT_FILE_PATH: String = "res://data/texts/fr.json"

var _texts: Dictionary = {}


func _ready() -> void:
	load_texts()


func load_texts() -> void:
	if not FileAccess.file_exists(TEXT_FILE_PATH):
		push_error("Fichier de textes introuvable : " + TEXT_FILE_PATH)
		_texts = {}
		return

	var file := FileAccess.open(TEXT_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Impossible d'ouvrir le fichier de textes : " + TEXT_FILE_PATH)
		_texts = {}
		return

	var raw_content := file.get_as_text()
	var parsed_data = JSON.parse_string(raw_content)

	if typeof(parsed_data) != TYPE_DICTIONARY:
		push_error("Le fichier de textes n'est pas un JSON valide : " + TEXT_FILE_PATH)
		_texts = {}
		return

	_texts = parsed_data


func get_text(key: String) -> String:
	if not _texts.has(key):
		push_warning("Clé de texte manquante : " + key)
		return key

	return str(_texts[key])


func get_text_with_values(key: String, values: Dictionary) -> String:
	var result := get_text(key)

	for value_key in values.keys():
		var placeholder := "{" + str(value_key) + "}"
		result = result.replace(placeholder, str(values[value_key]))

	return result
