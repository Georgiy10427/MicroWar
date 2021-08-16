extends Node

# Level's spawning settings
var x_pos = 0
var default_level_width = 1920

# Links to game's objects
var levels = ["res://levels/Lobby.tscn", "res://levels/TheOutOfCity_fixed.tscn"]
var player_link = "res://assets/Player/Player.tscn"
var overlay_link = "res://assets/GUI/HP_Bar/HP_Bar.tscn"

# For instances of game objects
var player: KinematicBody2D = null
var overlay: Node2D = null
var escape_dialog:Node2D = null
var time_machine:Node = null

func get_level_width(level_instance):
	var width = 0
	var location_scale:Vector2 = level_instance.get_scale()
	var location_end:Position2D = level_instance.find_node("End", true, true)
	
	if location_end != null and location_end is Position2D:
			width = location_end.position.x * location_scale.x
	else:
			print("Can't calculate location_width!")
			width += default_level_width
	return width
	

func environment_init():
	var broken_levels: Array = []
	for link in levels:
		var level = load(link)
		if level == null:
			print("ERROR! Failed to load location: " + link)
			broken_levels.append(link)
			continue
		
		var level_instance = level.instance()
		level_instance.position.x += x_pos
		add_child(level_instance)
		
		x_pos += get_level_width(level_instance)
	
	if broken_levels == []:
		return 0
	else:
		return broken_levels 

func player_init():
	player = load(player_link).instance()
	player.position.x = 35
	add_child(player)
	return player

func overlay_init():
	overlay = load(overlay_link).instance()
	add_child(overlay)
	return overlay

func _ready():
	environment_init()
	player_init()
	overlay_init()

# Unload a unused level
func unload_prev_level(self_level):
	var children:Array = get_children()
	var index:int = children.find(self_level)
	# Errors processing 
	if index == -1:
		# Nothing found
		print("Nothing to delete!")
		return -1
	elif index == 0:
		# The previous level is the first level 
		return 1
	# Unload the previous (unused) level
	else:
		var prev_level = get_child(index - 1)
		if prev_level is Node2D and  \
			not "Escape" in prev_level.name and \
			not "Player" in prev_level.name and \
			not "TimeMachine" in prev_level.name: 
			prev_level.queue_free()
			remove_child(prev_level)
			print("Success unload prev level.")
			return 0
		else:
			print("Can't unload prev level.")

func get_level_x_pos(index):
	var i = 0
	var x_position = 0
	for link in levels:
		var level = load(link)
		if level == null:
			print("ERROR! Failed to load location: " + link)
			continue
		
		if i == index:
			return x_position
		
		var level_instance = level.instance()
		x_position += get_level_width(level_instance)
		i += 1
	print_debug("Error get level x position!")
	return -1

func get_level_index(level):
	return levels.find(level.get_filename())

func load_prev_level(self_level):
	var index = get_level_index(self_level) - 1
	if index < 0:
		print_debug("Error load level!")
		return -1
	
	var x_position = get_level_x_pos(index)
	if x_position == -1:
		print_debug("Не удалось спозиционировать уровень!")
		return -1
	var level = load(levels[index])
	var level_instance = level.instance()
	
	level_instance.position.x += x_position
	call_deferred("add_child_below_node", get_children()[1], level_instance)
	return 0
