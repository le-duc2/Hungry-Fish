extends Node

signal ScoreAdded
@onready var score: int = 0

# == Variables == #


func _ready():
	add_to_group("player")
	
func set_score(value: int) -> void:
	score = value
	
	
func add(points: int) -> void:
	set_score(score + points)
	ScoreAdded.emit()
	
	
# == Add / Set Functions == #
