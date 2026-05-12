extends Node
class_name GameScore

signal score_changed(new_score: int)

var score: int = 0


func _ready() -> void:
	score_changed.emit(score)


func reset_score() -> void:
	score = 0
	score_changed.emit(score)


func add_score(amount: int) -> void:
	if amount <= 0:
		return

	score += amount
	score_changed.emit(score)


func get_score() -> int:
	return score
