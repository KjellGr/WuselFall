extends Node2D


export (float) var gravity = 1
export (float) var terminal_velocity = 5
export (float) var terminal_max = 100
export (float) var terminal_increase = 0.1
export (float) var enemy_speed = 50
export (float) var enemy_speed_increase = 1

export (float) var kill_distance = 1000
var jumpable = true
var fall = 0
var pos = 0
var score = 0
onready var LWall = $Walls_BG/LeftWAll/CollisionShape2D/Sprite.material
onready var RWall = $Walls_BG/RightWall/CollisionShape2D/Sprite.material
onready var BG = $Walls_BG/BG.material
onready var terrmtograv = gravity/terminal_velocity
onready var Enemy = load("res://Enemy.tscn")
onready var Spikes = load("res://Spikes.tscn")
onready var label = $Camera2D/ReferenceRect/Label


func _process(delta):
	fall = clamp(fall + gravity * delta , 0, terminal_velocity)
	gravity = terminal_velocity * terrmtograv
	if Input.is_action_just_pressed("JUMP") and jumpable:
		jumpable = false;
		jump()
	pos = (pos + fall/64) - (int(pos) if pos>=25 else 0)
	LWall.set_shader_param("position", pos)
	RWall.set_shader_param("position", pos)
	BG.set_shader_param("position", pos/25)
	terminal_velocity = clamp(terminal_velocity + terminal_increase * delta, 0, terminal_max)
	enemy_speed += enemy_speed_increase * delta
	score += fall
	label.text = String(int(score))
	
	
func jump():
	fall = 0


func _on_EnemyTimer_timeout():
	var e = Enemy.instance()
	e.moving = bool(randi()%2)
	e.killable = bool(randi()%2)
	e.position = Vector2(rand_range(-400, 400), 1000)
	add_child(e)
	$EnemyTimer.wait_time = rand_range(0, 4)
	$EnemyTimer.start()
	

func _on_SpikeTimer_timeout():
	var s = Spikes.instance()
	s.rightside = bool(randi()%2)
	s.position = Vector2(0, 1000)
	add_child(s)
	$SpikeTimer.wait_time = rand_range(4, 10)
	$SpikeTimer.start()
