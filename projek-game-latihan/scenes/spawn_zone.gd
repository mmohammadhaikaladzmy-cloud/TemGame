extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_area: Area2D  # drag your Area2D node here
@export var enemy_count: int = 5

func _ready():
	spawn_enemies()

func spawn_enemies():
	for i in range(enemy_count):
		var enemy = enemy_scene.instantiate()
		enemy.global_position = get_random_point_in_area(spawn_area)
		add_child(enemy)

func get_random_point_in_area(area: Area2D) -> Vector2:
	var collision_shape = area.get_node("CollisionShape2D") as CollisionShape2D
	var shape = collision_shape.shape

	var local_point: Vector2

	if shape is RectangleShape2D:
		var size = shape.size  # Godot 4 uses `size`, not `extents`
		local_point = Vector2(
			randf_range(-size.x / 2, size.x / 2),
			randf_range(-size.y / 2, size.y / 2)
		)
	elif shape is CircleShape2D:
		var radius = shape.radius
		var angle = randf_range(0, TAU)
		var dist = sqrt(randf()) * radius  # sqrt for even distribution across the disc
		local_point = Vector2(cos(angle), sin(angle)) * dist
	else:
		push_warning("Unsupported shape type for spawn area")
		local_point = Vector2.ZERO

	# Convert from the shape's local space to global space,
	# accounting for the CollisionShape2D's own position/rotation within the Area2D
	return collision_shape.global_transform * local_point
