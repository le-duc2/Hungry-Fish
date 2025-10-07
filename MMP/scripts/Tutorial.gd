extends Label

func _input(event):
	if event is InputEventMouseButton:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1)
		tween.tween_callback(self.queue_free)
