extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var warning_text: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var skip_prompt: Label = $CanvasLayer/SkipPrompt

var can_skip: bool = false
var is_transitioning: bool = false

func _ready() -> void:
	# 1. Background Hitam Pekat Fullscreen
	color_rect.anchors_preset = Control.PRESET_FULL_RECT
	color_rect.size = get_viewport_rect().size
	color_rect.color = Color.BLACK
	
	# 2. Atur Warna Teks Utama Merah & Sembunyikan Teks di Awal
	warning_text.add_theme_color_override("default_color", Color.RED)
	warning_text.modulate.a = 0.0
	
	if skip_prompt:
		skip_prompt.modulate.a = 0.0
	
	_jalankan_intro()

func _jalankan_intro() -> void:
	# 1. Fade-in Teks Peringatan (1.2 detik)
	var tween_in = create_tween()
	tween_in.tween_property(warning_text, "modulate:a", 1.0, 1.2)
	await tween_in.finished

	# 2. Tunggu hingga detik ke-5 untuk memunculkan Tulisan Skip
	await get_tree().create_timer(3.8).timeout # (1.2s fade + 3.8s = total 5.0s)
	
	if is_transitioning:
		return
		
	can_skip = true
	
	# Munculkan Tulisan Skip di Detik ke-5
	if skip_prompt:
		var tween_prompt = create_tween()
		tween_prompt.tween_property(skip_prompt, "modulate:a", 0.7, 0.8)

	# 3. Tunggu sisa waktu hingga total 20 detik untuk Auto-Skip
	await get_tree().create_timer(15.0).timeout # (5.0s + 15.0s = total 20.0s)
	
	if not is_transitioning:
		_pindah_ke_main_menu()

func _unhandled_input(event: InputEvent) -> void:
	# Pemain HANYA BISA SKIP setelah detik ke-5 (saat can_skip = true)
	if can_skip and not is_transitioning:
		if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
			can_skip = false
			_pindah_ke_main_menu()

func _pindah_ke_main_menu() -> void:
	is_transitioning = true
	can_skip = false
	
	# Fade-out Teks Peringatan & Tulisan Skip secara mulus
	var tween_out = create_tween().set_parallel(true)
	tween_out.tween_property(warning_text, "modulate:a", 0.0, 0.8)
	
	if skip_prompt:
		tween_out.tween_property(skip_prompt, "modulate:a", 0.0, 0.8)
		
	await tween_out.finished
	
	# Pindah ke Scene Main Menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
