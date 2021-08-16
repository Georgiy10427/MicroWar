# Singleton

# If the loading crashes, delete the file in C:\Users\Username\AppData\Roaming\Godot\app_userdata\your_godot_project
# and check if the values loaded match the values saved

extends Node

onready var player = null # to save the player's position 
var saves_path = "user://save.dat"
var flag_path = "user://load_last.dat"
var file = File.new()

func reload():
	yield(get_tree().create_timer(0.5), "timeout")
	var result = load_game()
	can_use = false
	yield(get_tree().create_timer(0.5), "timeout")
	can_use = true
	return result

func get_player():
	var world = get_parent()
	for object in world.get_children():
		if object.name == "Player" and object is KinematicBody2D:
			return object
	return null

func load_game():
	# Check errors
	# File don't exist error
	if !file.file_exists(saves_path):
		print_debug("Time machine error! Save don't exists.")
		return -1
	
	# Delay КОСТЫЛЬ!!
	yield(get_tree().create_timer(0.1), "timeout")
	
	player = get_parent().find_node("Player", true, false)
	
	# Can't find player error
	if player == null:
		print("Time machine error! Can't find player.")
		return -2
	
	file.open(saves_path, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	player.global_position = str2var(data["position"])
	player.Health = str2var(data["health"])
	player.Power = str2var(data["power"])
	player.rotation = 0
	
	var hour_save = int(str(data["timestamp"]).split(":")[0])
	var minute_save = int(str(data["timestamp"]).split(":")[1])
	var date_save = data["date"]

	print("Success load game from " + str(hour_save) + ":" + str(minute_save) 
		  + " " + date_save + " timestamp.")

	return 0


func save_game():
	file.open(saves_path, File.WRITE)
	
	player = get_parent().find_node("Player", true, false)
	
	# Edit this line with what you want to save:
	print("Scene: " + get_parent().get_filename())
	file.store_line(to_json({
							"level" : get_parent().get_filename(),
							"position" : var2str(player.global_position),
							"health" : var2str(player.Health),
							"power" : var2str(player.Power),
							"timestamp" : str(OS.get_time()["hour"]) + ":" + str(OS.get_time()["minute"]),
							"date" : str(OS.get_date()["day"]) + 
									'/' + str(OS.get_date()["month"]) +
									'/' + str(OS.get_date()["year"])  
							}))
	file.close()
	print("Success save game!")
	return 0

func continue_game():
	if file.file_exists(saves_path):
		var flag_file = File.new()
		flag_file.open(flag_path, File.WRITE)
		flag_file.close()
		
		file.open(saves_path, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		
		$Transit.change_scene(data["level"], 0.5, 0.2)
		return 0
	else:
		print("Save doesn't exist.")
		return -1

func _ready():
	pause_mode = PAUSE_MODE_PROCESS # This script can't get paused
	if file.file_exists(flag_path):
		var dir = Directory.new()
		dir.remove(flag_path)
		load_game()

var can_use = true # To avoid spamming quick save and quick load a boolean with a yield is used

func _input(_event):
	if can_use:
		if Input.is_action_pressed("ui_save"): # Quick save
			save_game()
			can_use = false
			yield(get_tree().create_timer(0.5), "timeout")
			can_use = true
			
		if Input.is_action_pressed("ui_load"): # Quick load
			load_game()
			can_use = false
			yield(get_tree().create_timer(0.5), "timeout")
			can_use = true

func get_number_of_saves():
	if file.file_exists(saves_path):
		return 1
	else:
		return 0
