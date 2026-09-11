extends Sprite2D

@export var amplitude: float = 4.0  # Jarak naik-turun (pixel)
@export var speed: float = 3.0      # Kecepatan gerak

var start_y: float

func _ready() -> void:
	start_y = position.y

func _process(delta: float) -> void:
	position.y = start_y + sin(Time.get_ticks_msec() * 0.001 * speed) * amplitude
