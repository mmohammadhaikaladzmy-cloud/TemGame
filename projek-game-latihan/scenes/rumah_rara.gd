extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var dialog_text: RichTextLabel = $CanvasLayer/DialogText
@onready var choice_container: HBoxContainer = $CanvasLayer/ChoiceContainer

# Menggunakan TextureButton
@onready var btn_end1: TextureButton = $CanvasLayer/ChoiceContainer/ButtonEnd1
@onready var btn_end2: TextureButton = $CanvasLayer/ChoiceContainer/ButtonEnd2

var _bisa_skip: bool = false
var _sedang_ending: bool = false

func _ready() -> void:
	# Aktifkan BBCode
	dialog_text.bbcode_enabled = true
	
	# Sembunyikan UI awal
	color_rect.visible = false
	color_rect.color = Color(0, 0, 0, 0)
	dialog_text.visible = false
	choice_container.visible = false
	
	# Sambungkan sinyal klik TextureButton
	if not btn_end1.pressed.is_connected(_on_button_end_1_pressed):
		btn_end1.pressed.connect(_on_button_end_1_pressed)
	if not btn_end2.pressed.is_connected(_on_button_end_2_pressed):
		btn_end2.pressed.connect(_on_button_end_2_pressed)
	
	_jalankan_cutscene_jalan()

func _unhandled_input(event: InputEvent) -> void:
	if _sedang_ending and _bisa_skip:
		if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
			_pindah_ke_main_menu()

func _jalankan_cutscene_jalan() -> void:
	player.set_physics_process(false)
	
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("walk_up")
	
	var target_pos = player.global_position + Vector2(0, -120)
	var walk_tween = create_tween()
	walk_tween.tween_property(player, "global_position", target_pos, 3.0)
	await walk_tween.finished
	
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").stop()
		player.get_node("AnimatedSprite2D").frame = 1
		
	await get_tree().create_timer(2.0).timeout
	_tampilkan_pilihan()

func _tampilkan_pilihan() -> void:
	dialog_text.visible = true
	dialog_text.text = "[center]Rara telah sampai di depan rumahnya.\nApa yang akan Rara lakukan pada pusaka ini?[/center]"
	
	choice_container.visible = true

func _on_button_end_1_pressed() -> void:
	_proses_fade_out_ending(
		"[center][color=green]GOOD ENDING[/color]\n\nRara menghancurkan pusaka tersebut di reruntuhan rumahnya. Api ritual padam dan kutukan Keluarga Gaok terputus untuk selamanya.[/center]"
	)

func _on_button_end_2_pressed() -> void:
	_proses_fade_out_ending(
		"[center][color=red]BAD ENDING[/color]\n\nRara menggenggam erat pusaka tersebut. Kegelapan dari rumah yang terbakar merasuki tubuhnya... Rara menjadi inang baru Keluarga Gaok.[/center]"
	)

func _proses_fade_out_ending(teks_penjelasan: String) -> void:
	_sedang_ending = true
	choice_container.visible = false
	dialog_text.visible = false
	
	# Layer Hitam Paling Atas (Layer 100)
	var top_layer = CanvasLayer.new()
	top_layer.layer = 100
	add_child(top_layer)
	
	var black_screen = ColorRect.new()
	black_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	black_screen.color = Color(0, 0, 0, 0.0)
	black_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_layer.add_child(black_screen)
	
	# Fade Out Hitam (1.5 detik)
	var fade_tween = create_tween()
	fade_tween.tween_property(black_screen, "color", Color(0, 0, 0, 1.0), 1.5)
	await fade_tween.finished
	
	# Pindahkan Teks ke Layer Atas
	dialog_text.get_parent().remove_child(dialog_text)
	top_layer.add_child(dialog_text)
	
	dialog_text.bbcode_enabled = true
	dialog_text.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	dialog_text.size = Vector2(800, 400)
	dialog_text.position = (get_viewport_rect().size / 2) - (dialog_text.size / 2)
	
	dialog_text.text = teks_penjelasan
	dialog_text.visible = true
	
	# Tunggu 4 detik sebelum izinkan skip
	await get_tree().create_timer(4.0).timeout
	
	dialog_text.text = teks_penjelasan + "\n\n\n[center][i][color=gray]- Klik / Tekan Sembarang Tombol untuk Lanjut -[/color][/i][/center]"
	_bisa_skip = true

func _pindah_ke_main_menu() -> void:
	_bisa_skip = false
	_sedang_ending = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
