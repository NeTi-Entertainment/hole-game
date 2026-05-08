extends CharacterBody3D

@export var move_speed: float = 6.0

var _input_direction: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	_update_input_direction()
	_apply_movement()


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
