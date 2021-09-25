## This is script that controls the water body
## It contains all the springs of our water
extends Node2D

export var k = 0.050
export var d = 0.03
export var spread = 0.1

# The spring array
var springs = [] 
var passes = 6

# Dstance in pixel between each springs
export var distance_between_springs = 64.0
# Number of spring in the scene
export var spring_number = 6

# Total water body lenght
var water_lenght = distance_between_springs * spring_number
# Springs scene reference
onready var water_spring = preload("res://assets/Water/Water_Spring.tscn")
# The body of water depth
export var depth = 500
var target_height = position.y
# the position of the bottom of our body of water
var bottom = target_height + depth
# reference to our polygon2D
onready var water_polygon = $Water_Polygon
# reference to our water border
onready var water_border = $Water_Border
export var border_thickness = 1.1

onready var collisionShape = $Water_Body_Area/CollisionShape2D
onready var water_body_area = $Water_Body_Area

# Reference to the particle we just created
onready var splash_particle = preload("res://assets/Water/splash_particles.tscn")

var sleep:bool = true
var thread = Thread.new()

# Initialize the spring array and all the springs
func _ready():
	water_border.width = border_thickness
	
	spread = spread / 10
	
	# Loops through all the strings
	# Makes an array with all the springs
	# Initializes each spring
	for i in range(spring_number):
		# The string x position
		# They are genereted from left to right --> 0, 32, 64, 96...
		var x_position = distance_between_springs * i
		var w = water_spring.instance()
		
		add_child(w)
		springs.append(w)
		w.initialize(x_position, i)
		w.set_collision_width(distance_between_springs)
		w.connect("splash", self, "splash")
	
	# Calculate the total lenght of the water body   
	var total_lenght = distance_between_springs * (spring_number - 1)
	# Create a new rectangle shape 2D
	var rectangle = RectangleShape2D.new().duplicate()
	
	var rect_position = Vector2(total_lenght / 2, depth / 2)
	var rect_extenst = Vector2(total_lenght / 2, depth / 2)
	
	water_body_area.position = rect_position
	rectangle.set_extents(rect_extenst)
	collisionShape.set_shape(rectangle)

func _physics_process(_delta):
	thread.start(self, "water_process")
	if thread.is_active():
		thread.wait_to_finish()

func water_process():
	if sleep:
		return
	
	# Moves all the springs accordingly
	for i in springs:
		i.water_update(k, d)
	
	# Represents the movement of the left and right neightbor of the springs
	
	var left_deltas = []
	var right_deltas = [] 
	
	# Initialize the values with an array of zeros
	for _i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for _j in range(passes):
	# Loops through each springs of out array
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			# Adds velocity to the springs to the RIGHT of the current spring
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	new_border()
	draw_water_body()

# This function adds a speed to a spring with this index
func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

func draw_water_body():
	# Gets the curve of the border
	var curve = water_border.curve
	
	# Makes an array of the points in the curve
	var points = Array(curve.get_baked_points())
	
	var water_polygon_points = points
	
	# Gets the first and last indexes of our surface array
	var first_index = 0
	var last_index = water_polygon_points.size()-1
	
	# Add other two points at the bottom of the polygon, to close the water body
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	
	# Transform our normal array into a poolvector2array
	# The polygon draw function uses poolvector2arrays to draw the polygon, so we converted it 
	water_polygon_points = PoolVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)

func new_border():
	# Creates a new curve 2D
	var curve = Curve2D.new().duplicate()
	
	var surface_points = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	
	water_border.curve = curve
	water_border.smooth(true)
	water_border.update()

func _on_Water_Body_Area_body_entered(body):
	if body.name == "CollisionWater":
		return

	# Creates a instace of the particle system
	var s = splash_particle.instance()
	
	#adds the particle to the scene
	get_tree().current_scene.add_child(s)
	
	#sets the position of the particle to the same of the body
	s.global_position = body.global_position

