extends CharacterBody2D

@export var speed = 50

var player: CharacterBody2D
@export var canChase = false
	
func _physics_process(delta: float) -> void:
	if canChase:
		if player == null:
			player = get_tree().get_first_node_in_group("player")
		if player:
			move(player)

func move(target):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
