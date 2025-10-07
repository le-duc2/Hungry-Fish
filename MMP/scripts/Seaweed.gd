extends Area2D

@export var Points: int = 3


func _ready():
	connect("body_entered", self._on_body_entered)
	
	var Sprite:AnimatedSprite2D = $AnimatedSprite2D
	var value = randi_range(1, 2)
	if value == 1:
		Sprite.play("Seaweed1")
		Sprite.z_index = 0
	else:
		Sprite.play("Seaweed2")
		Sprite.z_index = 2


func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and Score.score >= 0:
		queue_free()
		
		Score.add(Points)
