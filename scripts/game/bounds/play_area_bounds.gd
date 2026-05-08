extends Node3D
class_name PlayAreaBounds

@export var half_size: Vector2 = Vector2(9.0, 9.0)


func clamp_world_position(world_position: Vector3, radius: float) -> Vector3:
	var clamped_position := world_position

	clamped_position.x = clampf(
		world_position.x,
		-half_size.x + radius,
		half_size.x - radius
	)

	clamped_position.z = clampf(
		world_position.z,
		-half_size.y + radius,
		half_size.y - radius
	)

	return clamped_position


func is_position_inside(world_position: Vector3, radius: float) -> bool:
	if world_position.x < -half_size.x + radius:
		return false

	if world_position.x > half_size.x - radius:
		return false

	if world_position.z < -half_size.y + radius:
		return false

	if world_position.z > half_size.y - radius:
		return false

	return true
