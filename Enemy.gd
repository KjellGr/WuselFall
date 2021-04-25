extends KinematicBody2D


var moving = false;
var direction = 0;
var fall;
var speed = 0;
var velocity = Vector3.ZERO
var killable = true
onready var world = get_node("/root/World")
onready var kill_distance = world.kill_distance

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/Sprite/AnimationPlayer.play("wiggle")
	if moving:
		direction = randi()%2
		if not direction:
			direction = -1
		speed = world.enemy_speed
	if killable:
		$CollisionShape2D/Sprite.modulate = Color(.2,.2,1,1)
	else:
		$CollisionShape2D/Sprite.modulate = Color(1,0,0,1)


func _process(delta):
	fall = world.fall
	velocity = Vector2.ZERO
	velocity.y -= fall
	velocity.x = direction * speed * delta
	var coll = move_and_collide(velocity)
	if coll:
		direction -= direction	
	if position.y > kill_distance:
		queue_free()

func kill():
	if killable:
		world.score += 1000
		queue_free()
		return true
	return false
