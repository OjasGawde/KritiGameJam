extends KinematicBody2D

var max_speed = 1200 #max speed of hero
var speed = 0 #current speed of hero
var gravity = 10 #gravity applied when 
var accleration = 3000 #accleration hero
var move_direction #direction of motion of hero
var is_grappling = false #flag for movement of hero
var destination = Vector2() #destination of hero
var movement = Vector2() #movement to be pushed to the engine
var grapeller_length = 1000

onready var enviroment = $"../GrappleAbleTileMap"

func _unhandled_input(event):
	if event.is_action_pressed("Left Click"):
		destination = get_global_mouse_position()
		if position.distance_to(destination) < grapeller_length and enviroment.get_cellv(enviroment.world_to_map(destination)) != -1:
			is_grappling = true


func _physics_process(delta):
	move_hero(delta)


func move_hero(delta):
	if is_grappling == false:
		movement.y = min((movement.y + gravity), max_speed)
	else:
		speed += accleration * delta
		if speed > max_speed:
			speed = max_speed
		movement = position.direction_to(destination) * speed
	
	if position.distance_to(destination) < 40:
		is_grappling = false
	movement = move_and_slide(movement,Vector2.UP)
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		movement.x = 0
		is_grappling = false
