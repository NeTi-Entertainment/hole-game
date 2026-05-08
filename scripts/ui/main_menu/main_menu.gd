extends Control

@onready var play_button: Button = %PlayButton
@onready var shop_button: Button = %ShopButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var button_column: VBoxContainer = %ButtonColumn
@onready var safe_area_margin: MarginContainer = %SafeAreaMargin


func _ready() -> void:
	_apply_texts()
	_connect_buttons()
	_apply_responsive_layout()


func _notification(what: int) -> void:
	if what != NOTIFICATION_RESIZED:
		return

	if not is_node_ready():
		return

	_apply_responsive_layout()


func _apply_texts() -> void:
	play_button.text = TextDatabase.get_text("main_menu.play")
	shop_button.text = TextDatabase.get_text("main_menu.shop")
	settings_button.text = TextDatabase.get_text("main_menu.settings")
	quit_button.text = TextDatabase.get_text("main_menu.quit")


func _connect_buttons() -> void:
	play_button.pressed.connect(SceneRouter.go_to_game)
	shop_button.pressed.connect(SceneRouter.go_to_shop)
	settings_button.pressed.connect(SceneRouter.go_to_settings)
	quit_button.pressed.connect(SceneRouter.quit_game)


func _apply_responsive_layout() -> void:
	if safe_area_margin == null:
		return

	if button_column == null:
		return

	var viewport_size := get_viewport_rect().size
	var is_portrait := viewport_size.y > viewport_size.x

	if is_portrait:
		_apply_mobile_portrait_layout()
	else:
		_apply_pc_landscape_layout()


func _apply_mobile_portrait_layout() -> void:
	safe_area_margin.add_theme_constant_override("margin_left", 32)
	safe_area_margin.add_theme_constant_override("margin_top", 64)
	safe_area_margin.add_theme_constant_override("margin_right", 32)
	safe_area_margin.add_theme_constant_override("margin_bottom", 64)

	button_column.add_theme_constant_override("separation", 20)

	for child in button_column.get_children():
		if child is Button:
			child.custom_minimum_size = Vector2(320, 72)


func _apply_pc_landscape_layout() -> void:
	safe_area_margin.add_theme_constant_override("margin_left", 64)
	safe_area_margin.add_theme_constant_override("margin_top", 64)
	safe_area_margin.add_theme_constant_override("margin_right", 64)
	safe_area_margin.add_theme_constant_override("margin_bottom", 64)

	button_column.add_theme_constant_override("separation", 16)

	for child in button_column.get_children():
		if child is Button:
			child.custom_minimum_size = Vector2(300, 60)
