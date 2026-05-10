extends Node3D

@export var consumable_scene: PackedScene
@export var spawn_root_path: NodePath
@export var play_area_bounds_path: NodePath

@export var consumable_count: int = 50
@export var spawn_y_position: float = 0.5
@export var minimum_distance_from_center: float = 2.0

var _spawn_root: Node3D = null
var _play_area_bounds: PlayAreaBounds = null
var _random := RandomNumberGenerator.new()


func _ready() -> void:
	_random.randomize()
	_resolve_references()
	_spawn_consumables()


func _resolve_references() -> void:
	if not spawn_root_path.is_empty():
		var found_spawn_root := get_node_or_null(spawn_root_path)

		if found_spawn_root is Node3D:
			_spawn_root = found_spawn_root

	if not play_area_bounds_path.is_empty():
		var found_bounds := get_node_or_null(play_area_bounds_path)

		if found_bounds is PlayAreaBounds:
			_play_area_bounds = found_bounds


func _spawn_consumables() -> void:
	if consumable_scene == null:
		push_error("ConsumableSpawner : aucune scène de consommable assignée.")
		return

	if _spawn_root == null:
		push_error("ConsumableSpawner : aucun SpawnRoot assigné.")
		return

	if _play_area_bounds == null:
		push_error("ConsumableSpawner : aucun PlayAreaBounds assigné.")
		return

	_clear_existing_consumables()

	for index in consumable_count:
		_spawn_one_consumable(index)


func _clear_existing_consumables() -> void:
	for child in _spawn_root.get_children():
		child.queue_free()


func _spawn_one_consumable(index: int) -> void:
	var consumable_instance := consumable_scene.instantiate()

	if not consumable_instance is Node3D:
		push_error("ConsumableSpawner : la scène instanciée doit hériter de Node3D.")
		consumable_instance.queue_free()
		return

	var consumable_node := consumable_instance as Node3D

	_spawn_root.add_child(consumable_node)

	consumable_node.name = "GeneratedConsumable_%03d" % index
	consumable_node.global_position = _get_random_spawn_position()


func _get_random_spawn_position() -> Vector3:
	var half_size := _play_area_bounds.half_size
	var position := Vector3.ZERO
	var attempts := 0

	while attempts < 50:
		position = Vector3(
			_random.randf_range(-half_size.x, half_size.x),
			spawn_y_position,
			_random.randf_range(-half_size.y, half_size.y)
		)

		if _is_valid_spawn_position(position):
			return position

		attempts += 1

	return position


func _is_valid_spawn_position(position: Vector3) -> bool:
	var flat_position := Vector2(position.x, position.z)

	if flat_position.length() < minimum_distance_from_center:
		return false

	return true
