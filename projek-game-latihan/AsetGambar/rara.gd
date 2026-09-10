extends CharacterBody2D

@export var SPEED: float = 50.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: String = "Down"

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED
	move_and_slide()

	if input_vector != Vector2.ZERO:
		# Menentukan animasi berjalan berdasarkan arah input
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				animated_sprite.play("WalkRight")
				last_direction = "Right"
			else:
				animated_sprite.play("WalkLeft")
				last_direction = "Left"
		else:
			if input_vector.y > 0:
				animated_sprite.play("WalkDown")
				last_direction = "Down"
			else:
				animated_sprite.play("WalkUp")
				last_direction = "Up"
	else:
		# Jika berhenti, hentikan animasi di frame pertama (Idle)
		animated_sprite.play("Walk" + last_direction)
		animated_sprite.stop()
		animated_sprite.frame = 1 # Frame tengah sebagai posisi diam
