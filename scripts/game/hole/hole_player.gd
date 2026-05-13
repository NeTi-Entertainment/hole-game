extends CharacterBody3D

@export var move_speed: float = 6.0
@export var play_area_bounds_path: NodePath
@export var game_score_path: NodePath

@onready var hole_consumer: HoleConsumer = %HoleConsumer
@onready var hole_growth: HoleGrowth = %HoleGrowth

var _input_direction: Vector3 = Vector3.ZERO
var _play_area_bounds: PlayAreaBounds = null
var _game_score: GameScore = null


func _ready() -> void:
	_resolve_play_area_bounds()
	_resolve_game_score()
	_connect_consumer()


func _physics_process(_delta: float) -> void:
	_update_input_direction()
	_apply_movement()
	_apply_bounds()


func _resolve_play_area_bounds() -> void:
	if play_area_bounds_path.is_empty():
		return

	var found_node := get_node_or_null(play_area_bounds_path)

	if found_node is PlayAreaBounds:
		_play_area_bounds = found_node


func _resolve_game_score() -> void:
	if game_score_path.is_empty():
		return

	var found_node := get_node_or_null(game_score_path)

	if found_node is GameScore:
		_game_score = found_node


func _connect_consumer() -> void:
	if hole_consumer == null:
		return

	if hole_consumer.consumable_consumed.is_connected(_on_consumable_consumed):
		return

	hole_consumer.consumable_consumed.connect(_on_consumable_consumed)


func _update_input_direction() -> void:
	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	_input_direction = Vector3(
		input_vector.x,
		0.0,
		input_vector.y
	)

	if _input_direction.length_squared() > 1.0:
		_input_direction = _input_direction.normalized()


func _apply_movement() -> void:
	velocity.x = _input_direction.x * move_speed
	velocity.z = _input_direction.z * move_speed
	velocity.y = 0.0

	move_and_slide()


func _apply_bounds() -> void:
	if _play_area_bounds == null:
		_resolve_play_area_bounds()

	if _play_area_bounds == null:
		return

	global_position = _play_area_bounds.clamp_world_position(
		global_position,
		_get_current_hole_radius()
	)


func _get_current_hole_radius() -> float:
	if hole_growth == null:
		return 1.0

	return hole_growth.get_current_radius()


func _on_consumable_consumed(score_value: int) -> void:
	if _game_score == null:
		_resolve_game_score()

	if _game_score != null:
		_game_score.add_score(score_value)
	else:
		push_warning("HolePlayer : aucun GameScore assigné.")

	if hole_growth != null:
		hole_growth.add_experience(score_value)
