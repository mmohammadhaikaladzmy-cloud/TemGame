extends Node2D

# SomeOtherScene.gd (attached to the root of SomeOtherScene)
@onready var body: CharacterBody2D = %CharacterBody2D

func move_body(offset: Vector2) -> void:
	body.position += offset
