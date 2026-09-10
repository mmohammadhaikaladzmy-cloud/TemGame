extends CharacterBody2D

@export var speed = 10
@export var expo_growth_rate = 0.75
@export var max_speed = 300

var player: CharacterBody2D
@export var canChase = false
	
func _physics_process(delta: float) -> void:
	if canChase:
		if player == null:
			player = get_tree().get_first_node_in_group("player")
		if player:
			move(player, delta)
	else:
		speed = 10

func move(target, delta):
	var direction = (target.global_position - global_position).normalized()
	speed *= 1.0 + expo_growth_rate * delta
	speed = min(speed, max_speed)
	velocity = speed * direction
	move_and_slide()
