extends Control

@onready var game_viewport_container: SubViewportContainer = %GameViewportContainer
@onready var game_viewport: SubViewport = %GameViewport
@onready var back_button: Button = %BackButton


func _ready() -> void:
	_apply_texts()
	_connect_buttons()
	_apply_layout()


func _notification(what: int) -> void:
	if what != NOTIFICATION_RESIZED:
		return

	if not is_node_ready():
		return

	_apply_layout()


func _apply_texts() -> void:
	back_button.text = TextDatabase.get_text("common.back")


func _connect_buttons() -> void:
	back_button.pressed.connect(SceneRouter.go_to_main_menu)


func _apply_layout() -> void:
	_force_full_rect(game_viewport_container)
	_update_viewport_size()
	_apply_back_button_layout()


func _force_full_rect(control: Control) -> void:
	control.anchor_left = 0.0
	control.anchor_top = 0.0
	control.anchor_right = 1.0
	control.anchor_bottom = 1.0

	control.offset_left = 0.0
	control.offset_top = 0.0
	control.offset_right = 0.0
	control.offset_bottom = 0.0


func _update_viewport_size() -> void:
	var viewport_size := get_viewport_rect().size

	if viewport_size.x <= 0 or viewport_size.y <= 0:
		return

	game_viewport.size = Vector2i(
		int(viewport_size.x),
		int(viewport_size.y)
	)


func _apply_back_button_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var is_portrait := viewport_size.y > viewport_size.x

	if is_portrait:
		back_button.custom_minimum_size = Vector2(220, 64)
		back_button.offset_left = 24
		back_button.offset_top = 32
		back_button.offset_right = 244
		back_button.offset_bottom = 96
	else:
		back_button.custom_minimum_size = Vector2(160, 48)
		back_button.offset_left = 24
		back_button.offset_top = 24
		back_button.offset_right = 184
		back_button.offset_bottom = 72
