extends Node
class_name HoleGrowth

signal level_changed(new_level: int)
signal radius_changed(new_radius: float)
signal experience_changed(current_experience: int, required_experience: int)

@export var starting_level: int = 1
@export var base_radius: float = 1.0
@export var radius_per_level: float = 0.18

@export var base_experience_to_next_level: int = 5
@export var experience_required_increment_per_level: int = 3

@export var visual_root_path: NodePath
@export var movement_collision_path: NodePath
@export var hole_consumer_path: NodePath
@export var consumer_collision_path: NodePath
@export var progress_ring_fill_path: NodePath
@export var progress_ring_background_path: NodePath

@export var consumer_radius_margin: float = 0.08
@export var progress_ring_radius_offset: float = 0.28

var level: int = 1
var current_experience: int = 0
var required_experience: int = 5
var current_radius: float = 1.0

var _visual_root: Node3D = null
var _movement_collision: CollisionShape3D = null
var _hole_consumer: HoleConsumer = null
var _consumer_collision: CollisionShape3D = null
var _progress_ring_fill: HoleProgressRing = null
var _progress_ring_background: HoleProgressRing = null


func _ready() -> void:
	_initialize_values()
	_resolve_references()
	_duplicate_collision_shapes()
	_apply_current_state()


func add_experience(amount: int) -> void:
	if amount <= 0:
		return

	current_experience += amount

	while current_experience >= required_experience:
		current_experience -= required_experience
		_level_up()

	_apply_current_state()


func get_current_radius() -> float:
	return current_radius


func get_current_level() -> int:
	return level


func get_progress_ratio() -> float:
	if required_experience <= 0:
		return 0.0

	return float(current_experience) / float(required_experience)


func _initialize_values() -> void:
	level = max(1, starting_level)
	current_experience = 0
	required_experience = _get_required_experience_for_level(level)
	current_radius = _get_radius_for_level(level)


func _resolve_references() -> void:
	_visual_root = get_node_or_null(visual_root_path) as Node3D
	_movement_collision = get_node_or_null(movement_collision_path) as CollisionShape3D
	_hole_consumer = get_node_or_null(hole_consumer_path) as HoleConsumer
	_consumer_collision = get_node_or_null(consumer_collision_path) as CollisionShape3D
	_progress_ring_fill = get_node_or_null(progress_ring_fill_path) as HoleProgressRing
	_progress_ring_background = get_node_or_null(progress_ring_background_path) as HoleProgressRing


func _duplicate_collision_shapes() -> void:
	if _movement_collision != null and _movement_collision.shape != null:
		_movement_collision.shape = _movement_collision.shape.duplicate()

	if _consumer_collision != null and _consumer_collision.shape != null:
		_consumer_collision.shape = _consumer_collision.shape.duplicate()


func _level_up() -> void:
	level += 1
	required_experience = _get_required_experience_for_level(level)
	current_radius = _get_radius_for_level(level)

	level_changed.emit(level)
	radius_changed.emit(current_radius)


func _get_required_experience_for_level(target_level: int) -> int:
	return base_experience_to_next_level + ((target_level - 1) * experience_required_increment_per_level)


func _get_radius_for_level(target_level: int) -> float:
	return base_radius + ((target_level - 1) * radius_per_level)


func _apply_current_state() -> void:
	_apply_visual_radius()
	_apply_movement_collision_radius()
	_apply_consumer_radius()
	_apply_progress_ring()

	experience_changed.emit(current_experience, required_experience)


func _apply_visual_radius() -> void:
	if _visual_root == null:
		return

	_visual_root.scale = Vector3(current_radius, 1.0, current_radius)


func _apply_movement_collision_radius() -> void:
	if _movement_collision == null:
		return

	if not _movement_collision.shape is CylinderShape3D:
		return

	var cylinder_shape := _movement_collision.shape as CylinderShape3D
	cylinder_shape.radius = current_radius


func _apply_consumer_radius() -> void:
	if _hole_consumer != null:
		_hole_consumer.set_hole_radius(current_radius)

	if _consumer_collision == null:
		return

	if not _consumer_collision.shape is CylinderShape3D:
		return

	var cylinder_shape := _consumer_collision.shape as CylinderShape3D
	cylinder_shape.radius = current_radius + consumer_radius_margin


func _apply_progress_ring() -> void:
	var ring_radius := current_radius + progress_ring_radius_offset

	if _progress_ring_background != null:
		_progress_ring_background.set_radius(ring_radius)
		_progress_ring_background.set_progress_ratio(1.0)

	if _progress_ring_fill != null:
		_progress_ring_fill.set_radius(ring_radius)
		_progress_ring_fill.set_progress_ratio(get_progress_ratio())
