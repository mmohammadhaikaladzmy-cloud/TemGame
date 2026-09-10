extends PointLight2D

func _process(delta):
	# Membuat energi cahaya naik turun secara acak mirip api
	energy = randf_range(1.5, 2.2)
