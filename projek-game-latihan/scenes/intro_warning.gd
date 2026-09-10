extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var warning_text: RichTextLabel = $CanvasLayer/RichTextLabel

func _ready() -> void:
	# Bikin ColorRect full layar & hitam pekat
	color_rect.anchors_preset = Control.PRESET_FULL_RECT
	color_rect.size = get_viewport_rect().size
	color_rect.color = Color.BLACK
	
	# Warna teks merah
	warning_text.add_theme_color_override("default_color", Color.RED)
	warning_text.modulate.a = 0.0
	
	_jalankan_intro()

func _jalankan_intro() -> void:
	var tween_in = create_tween()
	tween_in.tween_property(warning_text, "modulate:a", 1.0, 1.2)
	await tween_in.finished
	
	# Tahan 8 detik
	await get_tree().create_timer(8.0).timeout
	
	_pindah_ke_main_menu()

func _pindah_ke_main_menu() -> void:
	var tween_out = create_tween()
	tween_out.tween_property(warning_text, "modulate:a", 0.0, 0.8)
	await tween_out.finished
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
