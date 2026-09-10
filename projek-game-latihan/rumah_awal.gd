extends Node2D

@onready var camera = $Player/Camera2D

func _ready() -> void:
	camera.limit_right = 1152
	camera.limit_bottom = 640
