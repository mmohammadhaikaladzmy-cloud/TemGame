extends CharacterBody2D

@export var speed = 100;
@export var godotsvg: CharacterBody2D

func _ready() -> void:
	add_to_group("player")

func get_input():
	# get movement input
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	velocity = input_dir * speed

func _physics_process(delta: float) -> void:
	get_input()
	
	move_and_collide(velocity * delta)
