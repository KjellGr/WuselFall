extends KinematicBody2D

var rightside = false
var fall;
onready var world = get_node("/root/World")
onready var kill_distance = world.kill_distance

# Called when the node enters the scene tree for the first time.
func _ready():
	if rightside:
		position = Vector2(-498, position.y)
	else:
		position = Vector2(498, position.y)
		$Sprite.flip_v = true


func _process(_delta):
	fall = world.fall
	var _coll = move_and_collide(Vector2(0, - fall))
	if position.y > kill_distance:
		queue_free()
