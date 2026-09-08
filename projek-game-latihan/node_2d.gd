extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(Input.get_vector("ui_up", "ui_down", "ui_right","ui_left")) # Replace with function body.
