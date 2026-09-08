extends CharacterBody2D

@export var speed = 100;
@export var godotsvg: CharacterBody2D

func get_input():
	# get movement input
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	velocity = input_dir * speed
	
	# get other inputs
	## reset godot.svg position input
	if Input.is_action_just_pressed("reset_godotsvg"):
		print("resetted!!!")
		godotsvg.set_position(Vector2(0,0))

func _physics_process(delta: float) -> void:
	get_input()
	
	move_and_collide(velocity * delta)
