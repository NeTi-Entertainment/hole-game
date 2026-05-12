extends Control

@export var game_score_path: NodePath

@onready var score_label: Label = %ScoreLabel

var _game_score: GameScore = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	_resolve_game_score()
	_connect_game_score()
	_refresh_score_text()


func _notification(what: int) -> void:
	if what != NOTIFICATION_RESIZED:
		return

	if not is_node_ready():
		return

	_apply_layout()


func _resolve_game_score() -> void:
	if game_score_path.is_empty():
		return

	var found_node := get_node_or_null(game_score_path)

	if found_node is GameScore:
		_game_score = found_node


func _connect_game_score() -> void:
	if _game_score == null:
		return

	if _game_score.score_changed.is_connected(_on_score_changed):
		return

	_game_score.score_changed.connect(_on_score_changed)


func _refresh_score_text() -> void:
	var score_amount := 0

	if _game_score != null:
		score_amount = _game_score.get_score()

	score_label.text = TextDatabase.get_text_with_values(
		"game.score",
		{
			"amount": score_amount
		}
	)

	_apply_layout()


func _on_score_changed(new_score: int) -> void:
	score_label.text = TextDatabase.get_text_with_values(
		"game.score",
		{
			"amount": new_score
		}
	)


func _apply_layout() -> void:
	var viewport_size := get_viewport_rect().size
	var is_portrait := viewport_size.y > viewport_size.x

	if is_portrait:
		_apply_mobile_portrait_layout()
	else:
		_apply_pc_landscape_layout()


func _apply_mobile_portrait_layout() -> void:
	score_label.offset_left = 24
	score_label.offset_top = 112
	score_label.offset_right = 360
	score_label.offset_bottom = 160


func _apply_pc_landscape_layout() -> void:
	score_label.offset_left = 24
	score_label.offset_top = 88
	score_label.offset_right = 320
	score_label.offset_bottom = 128
