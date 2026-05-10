extends CharacterBody3D

@export var move_speed: float = 6.0
@export var hole_radius: float = 1.0
@export var play_area_bounds_path: NodePath

@onready var hole_consumer: HoleConsumer = %HoleConsumer

var _input_direction: Vector3 = Vector3.ZERO
var _play_area_bounds: PlayAreaBounds = null
var _score: int = 0


func _ready() -> void:
	_resolve_play_area_bounds()
	_sync_consumer_radius()
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


func _sync_consumer_radius() -> void:
	if hole_consumer == null:
		return

	hole_consumer.set_hole_radius(hole_radius)


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
		hole_radius
	)


func _on_consumable_consumed(score_value: int) -> void:
	_score += score_value
	print("Objet mangé. Score : ", _score)
