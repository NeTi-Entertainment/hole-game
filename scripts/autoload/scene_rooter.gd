extends Node

const MAIN_MENU_SCENE_PATH: String = "res://scenes/ui/main_menu/main_menu.tscn"
const SHOP_SCENE_PATH: String = "res://scenes/ui/shop/shop_screen.tscn"
const GAME_SCENE_PATH: String = "res://scenes/game/game_screen.tscn"
const SETTINGS_SCENE_PATH: String = "res://scenes/ui/settings/settings_screen.tscn"

var _screen_container: Control = null
var _current_screen: Control = null


func set_screen_container(screen_container: Control) -> void:
	_screen_container = screen_container


func go_to_main_menu() -> void:
	_change_screen(MAIN_MENU_SCENE_PATH)


func go_to_shop() -> void:
	_change_screen(SHOP_SCENE_PATH)


func go_to_game() -> void:
	_change_screen(GAME_SCENE_PATH)


func go_to_settings() -> void:
	_change_screen(SETTINGS_SCENE_PATH)


func quit_game() -> void:
	get_tree().quit()


func _change_screen(scene_path: String) -> void:
	if _screen_container == null:
		push_error("SceneRouter : aucun conteneur d'écran assigné.")
		return

	var packed_scene := load(scene_path)
	if packed_scene == null:
		push_error("SceneRouter : scène introuvable : " + scene_path)
		return

	if _current_screen != null:
		_current_screen.queue_free()
		_current_screen = null

	var new_screen = packed_scene.instantiate()

	if not new_screen is Control:
		push_error("SceneRouter : la scène chargée doit hériter de Control : " + scene_path)
		new_screen.queue_free()
		return

	_current_screen = new_screen
	_screen_container.add_child(_current_screen)
	
	_current_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	_current_screen.offset_left = 0
	_current_screen.offset_top = 0
	_current_screen.offset_right = 0
	_current_screen.offset_bottom = 0
