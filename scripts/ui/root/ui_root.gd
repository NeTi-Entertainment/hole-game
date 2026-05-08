extends Control

@onready var screen_container: Control = $ScreenContainer


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	screen_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen_container.offset_left = 0
	screen_container.offset_top = 0
	screen_container.offset_right = 0
	screen_container.offset_bottom = 0

	SceneRouter.set_screen_container(screen_container)
	SceneRouter.go_to_main_menu()
