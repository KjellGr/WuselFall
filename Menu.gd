extends Control

var highscore

func _ready():
	load_score()
	var score = get_node("/root/Score").score
	if score > highscore:
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer2/HighScore2.text = "NEW HIGHSCORE"
		highscore = score
		save_score()
	else:
		$Panel/VBoxContainer/HBoxContainer/VBoxContainer2/HighScore2.text = String(highscore)
	$Panel/VBoxContainer/HBoxContainer/VBoxContainer2/Show_score.text = String(score)
	
	
func load_score():
	var file = File.new()
	if file.file_exists("user://score.save"):
		file.open("user://score.save", File.READ)
		highscore = file.get_var()
		file.close()
	else:
		highscore = 0

func save_score():
	var file = File.new()
	file.open("user://score.save", File.WRITE)
	file.store_var(highscore)
	file.close()

func _process(_delta):
	if Input.is_action_just_pressed("JUMP"):
		_on_Play_pressed()


func _on_Play_pressed():
	var _scene = get_tree().change_scene("res://World.tscn")


func _on_EXIT_pressed():
	get_tree().quit()
