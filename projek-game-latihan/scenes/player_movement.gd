extends CharacterBody2D

@export var speed = 100;
@onready var detection_radius = $detect_area
@onready var detection_shape = $detect_area/CollisionShape2D
@onready var flashlight_on = false
@onready var flashlight_light = $PointLight2D
@onready var flashlight_light2 = $PointLight2D
var tween: Tween


func _ready() -> void:
	add_to_group("player")
	detection_radius.area_entered.connect(_on_detection_area_entered)
	detection_radius.area_exited.connect(_on_detection_area_exited)

func get_input():
	# get movement input
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_dir * speed
	
	#flashlight
	if Input.is_action_just_pressed("flashlight_toggle"):
		flashlight_on = !flashlight_on
		
		if tween and tween.is_valid():
			tween.kill()
		
		if flashlight_on:
			detection_shape.global_scale = Vector2(21,21)
			flashlight_light.visible = true
			flashlight_light2.visible = true
			print("flashlight on")
		else:
			tween = create_tween()
			tween.set_trans(Tween.TRANS_EXPO)
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(detection_shape, "scale", Vector2(2.41, 2.41), 1.0)
			flashlight_light.visible = false
			flashlight_light2.visible = false
			print("flashlight off")

func _on_detection_area_entered(area: Area2D) -> void:
	if area.is_in_group("ghost_hitbox"):
		var ghost = area.get_parent()
		ghost.canChase = true
		print("Ghost entered")

func _on_detection_area_exited(area: Area2D) -> void:
	if area.is_in_group("ghost_hitbox"):
		var ghost = area.get_parent()
		ghost.canChase = false
		print("ghost exited")

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
