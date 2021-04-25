extends KinematicBody2D

export (float) var speed = 300
var direction
var velocity = Vector2(0,0)
var coll
var in_kill_area = []
var anim = "Fall"
onready var anim_player = $Sprite/AnimationPlayer
onready var anim_timer = $Sprite/Timer
onready var world = get_node("/root/World")

func _physics_process(delta):
	anim_player.play(anim)	
	if Input.is_action_just_pressed("ATTACK"):
		kill()
	velocity.x = 0;
	direction = 0;
	if Input.is_action_pressed("LEFT"):
		direction -= 1
	if Input.is_action_pressed("RIGHT"):
		direction += 1
	velocity.x = direction * delta * speed
	coll = move_and_collide(velocity)
	if coll:
		var groups = coll.collider.get_groups()
		if groups:
			groups = groups[0]
			if groups == "Wall":
				pass
			elif groups == "Enemy" or "Spikes":
				game_over()

func kill():
	anim = "Attack"
	$AudioStreamPlayer2D.play()
	anim_timer.start()
	for x in in_kill_area:
		var a = x.kill()
		if a:
			world.jumpable = true
		else:
			world.jump()

func game_over():
	get_node("/root/Score").score = int(world.score)
	var _scene = get_tree().change_scene("res://Menu.tscn")


func _on_Area2D_body_entered(body):
	if body.get_groups():
		if body.get_groups().has("Enemy"):
			in_kill_area.append(body)


func _on_Area2D_body_exited(body):
	if body.get_groups():
		if body.get_groups().has("Enemy"):
			in_kill_area.remove(in_kill_area.find(body))


func _on_Timer_timeout():
	anim = "Fall"
