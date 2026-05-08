extends Control

@onready var safe_area_margin: MarginContainer = %SafeAreaMargin
@onready var main_column: VBoxContainer = %MainColumn
@onready var title_label: Label = %TitleLabel
@onready var placeholder_label: Label = %PlaceholderLabel
@onready var back_button: Button = %BackButton


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
	title_label.text = TextDatabase.get_text("game_bootstrap.title")
	placeholder_label.text = TextDatabase.get_text("game_bootstrap.placeholder")
	back_button.text = TextDatabase.get_text("common.back")


func _connect_buttons() -> void:
	back_button.pressed.connect(SceneRouter.go_to_main_menu)


func _apply_responsive_layout() -> void:
	if safe_area_margin == null:
		return

	if main_column == null:
		return

	var viewport_size := get_viewport_rect().size
	var is_portrait := viewport_size.y > viewport_size.x

	if is_portrait:
		_apply_mobile_portrait_layout()
	else:
		_apply_pc_landscape_layout()


func _apply_mobile_portrait_layout() -> void:
	safe_area_margin.add_theme_constant_override("margin_left", 24)
	safe_area_margin.add_theme_constant_override("margin_top", 64)
	safe_area_margin.add_theme_constant_override("margin_right", 24)
	safe_area_margin.add_theme_constant_override("margin_bottom", 64)

	main_column.add_theme_constant_override("separation", 20)

	back_button.custom_minimum_size = Vector2(320, 64)


func _apply_pc_landscape_layout() -> void:
	safe_area_margin.add_theme_constant_override("margin_left", 96)
	safe_area_margin.add_theme_constant_override("margin_top", 64)
	safe_area_margin.add_theme_constant_override("margin_right", 96)
	safe_area_margin.add_theme_constant_override("margin_bottom", 64)

	main_column.add_theme_constant_override("separation", 16)

	back_button.custom_minimum_size = Vector2(280, 56)
