extends CharacterBody2D

@export var speed = 100

@onready var detection_radius = $detect_area
@onready var detection_shape = $detect_area/CollisionShape2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var flashlight_light = $PointLight2D
var tween: Tween
@onready var flashlight_light2 = $PointLight2D/PointLight2D # Menyesuaikan hierarki PointLight2D di scene player kamu sebelumnya

var flashlight_on = false

func _ready() -> void:
	add_to_group("player")
	detection_radius.area_entered.connect(_on_detection_area_entered)
	detection_radius.area_exited.connect(_on_detection_area_exited)

func get_input():
	# Get movement input
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	
	# Kontrol Animasi Rara
	_update_animation(input_dir)
	
	# Flashlight
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight_on = !flashlight_on
		
		if tween and tween.is_valid():
			tween.kill()
		
		if flashlight_on:
			detection_shape.global_scale = Vector2(21, 21)
			flashlight_light.visible = true
			if flashlight_light2:
				flashlight_light2.visible = true
			print("flashlight on")
		else:
			tween = create_tween()
			tween.set_trans(Tween.TRANS_EXPO)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(detection_shape, "scale", Vector2(2.41, 2.41), 1.0)
			flashlight_light.visible = false
			if flashlight_light2:
				flashlight_light2.visible = false
			print("flashlight off")

func _update_animation(input_dir: Vector2) -> void:
	if input_dir == Vector2.ZERO:
		# Jika berhenti, stop animasi dan kunci di frame diam (frame ke-2 / index 1)
		animated_sprite.stop()
		animated_sprite.frame = 1
	else:
		var target_anim = ""
		
		# Tentukan nama animasi berdasarkan arah
		if input_dir.x > 0:
			target_anim = "walk_right"
		elif input_dir.x < 0:
			target_anim = "walk_left"
		elif input_dir.y > 0:
			target_anim = "walk_down"
		elif input_dir.y < 0:
			target_anim = "walk_up"
		
		# KUNCI PERBAIKAN: Hanya panggil play() JIKA animasi yang berjalan berbeda!
		if animated_sprite.animation != target_anim:
			animated_sprite.play(target_anim)
func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("ghost_hitbox"):
		var ghost = area.get_parent()
		if ghost and "canChase" in ghost:
			ghost.canChase = true
			print("Ghost entered")

func _on_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group("ghost_hitbox"):
		var ghost = area.get_parent()
		if ghost and "canChase" in ghost:
			ghost.canChase = false
			print("Ghost exited")

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
