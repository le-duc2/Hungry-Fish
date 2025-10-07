extends CharacterBody2D

@onready var PointCounter:Label = get_node("/root/UI/Points")
@onready var Sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var Camera:Camera2D = $Camera2D
@onready var SwimingSFX = $SwimmingSFX
@onready var EatingSFX = $EatingSFX


@onready var Hitboxes = {
	1: {"Hitbox": $Hitbox1, "Size": 1},
	2: {"Hitbox": $Hitbox2, "Size": 2},
	3: {"Hitbox": $Hitbox3, "Size": 3},
}

@export var Speed:int = 100
var Moving: bool = false
var SFXPlaying:bool = false
const LevelDict = {
	1: {"Size":1, "Zoom": Vector2(8,8), "Speed":100, "Points":1},
	2: {"Size":2, "Zoom": Vector2(5,5), "Speed":150, "Points":20},
	3: {"Size":3, "Zoom": Vector2(3,3), "Speed":250, "Points":100}
}


# == Variables == #


func _input(event):
	if event is InputEventMouseButton:
		Moving = event.pressed



func _physics_process(_delta):

	var MousePosition = get_global_mouse_position()
	
	
	if Moving and global_position.distance_to(MousePosition) >= 10:
		if not SFXPlaying:
			SFXPlaying = true
			SwimingSFX.play()
		var direction = (MousePosition - global_position).normalized()
		velocity = direction * Speed
		move_and_slide()
	else:
		if SFXPlaying:
			SFXPlaying = false
			SwimingSFX.stop()
		velocity = Vector2.ZERO

	if MousePosition.x < global_position.x:
		Sprite.flip_v = false
	else:
		Sprite.flip_v = true
		
	look_at(MousePosition)
	rotation += deg_to_rad(-180)
	# == Movement Scripts == #


func _ready():
	Score.ScoreAdded.connect(OnScoreAdded)


func OnScoreAdded():
	EatingSFX.play()
	var result = 0
	for n in LevelDict.keys():
		if Score.score > LevelDict[n]["Points"]:
			result = LevelDict[n]
	# == Scanning the Dictionary == 
	
	print("Level: " + str(result["Size"]))
	PointCounter.text = "Points: " + str(Score.score) + "/221"
	Speed = result["Speed"]
	
	var ZoomTween = Camera.create_tween()
	ZoomTween.set_ease(Tween.EASE_IN)
	ZoomTween.set_trans(Tween.TRANS_LINEAR)
	ZoomTween.tween_property(Camera, "zoom", result["Zoom"], .5)
	
	Sprite.play(str(result["Size"]))
	
	for n in Hitboxes.keys():
		if Hitboxes[n]["Size"] == result["Size"]:
			Hitboxes[n]["Hitbox"].call_deferred("set_disabled", false)
		else:
			Hitboxes[n]["Hitbox"].call_deferred("set_disabled", true)
