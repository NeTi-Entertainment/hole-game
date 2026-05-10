extends Area3D
class_name HoleConsumer

signal consumable_consumed(score_value: int)

@export var hole_player_path: NodePath

var _hole_player: CharacterBody3D = null
var _current_hole_radius: float = 1.0


func _ready() -> void:
	_resolve_hole_player()
	body_entered.connect(_on_body_entered)


func set_hole_radius(hole_radius: float) -> void:
	_current_hole_radius = hole_radius


func _resolve_hole_player() -> void:
	if hole_player_path.is_empty():
		return

	var found_node := get_node_or_null(hole_player_path)

	if found_node is CharacterBody3D:
		_hole_player = found_node


func _on_body_entered(body: Node3D) -> void:
	if not body is Consumable:
		return

	var consumable := body as Consumable

	if not consumable.can_be_consumed_by(_current_hole_radius):
		return

	var score_value := consumable.consume()
	consumable_consumed.emit(score_value)
