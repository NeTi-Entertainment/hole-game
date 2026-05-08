extends Camera3D

@export var target_path: NodePath
@export var height: float = 12.0
@export var distance_back: float = 8.0
@export var fixed_rotation_degrees: Vector3 = Vector3(-55.0, 0.0, 0.0)

var _target: Node3D = null


func _ready() -> void:
	_resolve_target()
	_apply_fixed_rotation()
	_snap_to_target()


func _process(_delta: float) -> void:
	if _target == null:
		_resolve_target()

	if _target == null:
		return

	_follow_target_exactly()
	_apply_fixed_rotation()


func _resolve_target() -> void:
	if target_path.is_empty():
		return

	var found_node := get_node_or_null(target_path)

	if found_node is Node3D:
		_target = found_node


func _snap_to_target() -> void:
	if _target == null:
		return

	_follow_target_exactly()


func _follow_target_exactly() -> void:
	global_position = Vector3(
		_target.global_position.x,
		_target.global_position.y + height,
		_target.global_position.z + distance_back
	)


func _apply_fixed_rotation() -> void:
	rotation_degrees = fixed_rotation_degrees
