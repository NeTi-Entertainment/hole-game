extends StaticBody3D
class_name Consumable

@export var score_value: int = 1
@export var required_hole_radius: float = 1.0

var is_consumed: bool = false


func can_be_consumed_by(hole_radius: float) -> bool:
	if is_consumed:
		return false

	return hole_radius >= required_hole_radius


func consume() -> int:
	if is_consumed:
		return 0

	is_consumed = true
	queue_free()

	return score_value
