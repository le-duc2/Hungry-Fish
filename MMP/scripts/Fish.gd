extends Area2D

@export var Points: int = 5

func _ready():
	connect("body_entered", self._on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and Score.score >= 20:
		get_parent().queue_free()
		
		Score.add(Points)
