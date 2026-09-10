extends PointLight2D

@export var base_energy := 1.2
@export var flicker_min := 0.6
@export var flicker_max := 1.5
@export var min_interval := 0.05
@export var max_interval := 0.7

var _timer := 0.0
var _next_change := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_next_change = randf_range(min_interval, max_interval)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer += delta
	if _timer >= _next_change:
		_timer = 0.0
		_next_change = randf_range(min_interval, max_interval)
		energy = randf_range(flicker_min, flicker_max)
