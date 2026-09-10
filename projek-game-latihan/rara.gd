extends CharacterBody2D

@export var SPEED: float = 120.0
@onready var sprite: Sprite2D = $Sprite2D

var tween_bounce: Tween

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED
	move_and_slide()

	# Efek Flip Kiri/Kanan (memakai gambar depan)
	if input_vector.x != 0:
		sprite.flip_h = (input_vector.x < 0)

	# Efek Jalan Membal Naik-Turun
	if input_vector != Vector2.ZERO:
		_start_bounce()
	else:
		_stop_bounce()

func _start_bounce() -> void:
	if tween_bounce and tween_bounce.is_running():
		return
	
	tween_bounce = create_tween().set_loops()
	tween_bounce.tween_property(sprite, "position:y", -3.0, 0.15).set_trans(Tween.TRANS_SINE)
	tween_bounce.tween_property(sprite, "position:y", 0.0, 0.15).set_trans(Tween.TRANS_SINE)

func _stop_bounce() -> void:
	if tween_bounce:
		tween_bounce.kill()
		sprite.position.y = 0.
