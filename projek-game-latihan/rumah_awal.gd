extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var player_camera: Camera2D = $Player/Camera2D 
@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var trigger_area: Area2D = $CutsceneTrigger

@export var rumah_hancur_pos: Vector2 = Vector2(850, 200)

var _cutscene_berjalan: bool = false

# Node UI Otomatis
var dialog_layer: CanvasLayer
var dialog_box: Panel
var dialog_text: RichTextLabel

func _ready() -> void:
	_buat_ui_dialog_otomatis()
	
	if cutscene_camera:
		cutscene_camera.enabled = false
	
	if trigger_area and not trigger_area.body_entered.is_connected(_on_trigger_body_entered):
		trigger_area.body_entered.connect(_on_trigger_body_entered)

func _buat_ui_dialog_otomatis() -> void:
	# CanvasLayer khusus di Layer 100
	dialog_layer = CanvasLayer.new()
	dialog_layer.layer = 100
	add_child(dialog_layer)

	# Panel Kotak Dialog Hitam Transparan di Bawah
	dialog_box = Panel.new()
	dialog_box.custom_minimum_size = Vector2(800, 120)
	dialog_box.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	dialog_box.position.y -= 140
	dialog_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	dialog_box.visible = false
	dialog_layer.add_child(dialog_box)

	# Teks Tampilan (Rata Kiri)
	dialog_text = RichTextLabel.new()
	dialog_text.bbcode_enabled = true
	dialog_text.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dialog_text.offset_left = 30
	dialog_text.offset_top = 20
	dialog_text.offset_right = -30
	dialog_text.offset_bottom = -20
	dialog_box.add_child(dialog_text)

func _on_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not _cutscene_berjalan:
		_cutscene_berjalan = true
		_jalankan_cutscene()

func _jalankan_cutscene() -> void:
	# 1. Hentikan gerakan player
	player.set_physics_process(false)
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").stop()
		player.get_node("AnimatedSprite2D").frame = 1

	cutscene_camera.global_position = player.global_position
	cutscene_camera.zoom = player_camera.zoom
	cutscene_camera.enabled = true
	player_camera.enabled = false

	# 2. Dialog Awal
	await _tampilkan_dialog("Rara: \"Tunggu... apa yang terjadi di sana?!\"", 2.5)

	# 3. Kamera bergerak ke Rumah Hancur
	var cam_tween = create_tween()
	cam_tween.tween_property(cutscene_camera, "global_position", rumah_hancur_pos, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await cam_tween.finished

	# 4. Dialog di Rumah Hancur
	await _tampilkan_dialog("Rara: \"Rumahku... kenapa semuanya hancur berantakan?!\"", 3.0)
	await _tampilkan_dialog("Rara: \"Apakah ini perbuatan siluman Gaok Ireng...?\"", 3.0)
	
	dialog_box.visible = false
	await get_tree().create_timer(1.5).timeout

	# 5. Kembalikan Kamera ke Rara
	var cam_back_tween = create_tween()
	cam_back_tween.tween_property(cutscene_camera, "global_position", player.global_position, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await cam_back_tween.finished

	await _tampilkan_dialog("Rara: \"Aku harus segera pergi dari sini dan mencari petunjuk di hutan!\"", 3.0)
	dialog_box.visible = false

	# 6. Rara berjalan ke kiri tanpa diikuti kamera
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("walk_left")
		
	var target_jalan = player.global_position + Vector2(-300, 0)
	var walk_tween = create_tween()
	walk_tween.tween_property(player, "global_position", target_jalan, 3.5)
	await walk_tween.finished

	# =========================================================
	# 7. PROSES FADE OUT KE HITAM & STORY LANJUTAN
	# =========================================================
	
	# Buat layar hitam paling atas (Layer 120)
	var fade_layer = CanvasLayer.new()
	fade_layer.layer = 120
	add_child(fade_layer)

	var black_screen = ColorRect.new()
	black_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	black_screen.color = Color(0, 0, 0, 0.0) # Transparan di awal
	fade_layer.add_child(black_screen)

	# Efek Fade Out Hitam (1.5 detik)
	var fade_tween = create_tween()
	fade_tween.tween_property(black_screen, "color", Color(0, 0, 0, 1.0), 1.5)
	await fade_tween.finished

	# Pindahkan kotak dialog ke Layer Layar Hitam agar muncul di atas warna hitam
	dialog_box.get_parent().remove_child(dialog_box)
	fade_layer.add_child(dialog_box)

	# --- LANJUTAN STORY KAMU BISA DITAMBAHKAN DI SINI ---
	await _tampilkan_dialog("Rara berjalan menyusuri jalanan sepi menuju hutan kegelapan...", 3.5)
	await _tampilkan_dialog("Tanpa ia sadari, bahaya besar sedang mengintip dari balik pepohonan.", 3.5)
	# (Kamu bisa menambah baris await _tampilkan_dialog(...) lagi jika masih ada cerita)

	dialog_box.visible = false
	await get_tree().create_timer(1.0).timeout

	# 8. Baru Pindah ke Scene Hutan
	get_tree().change_scene_to_file("res://scenes/hutan.tscn")

# Fungsi Tampil Dialog dengan Efek Ketik
func _tampilkan_dialog(teks: String, durasi: float) -> void:
	dialog_text.text = "[left]" + teks + "[/left]"
	dialog_text.visible_ratio = 0.0
	dialog_box.visible = true
	
	var text_tween = create_tween()
	text_tween.tween_property(dialog_text, "visible_ratio", 1.0, 1.2)
	await text_tween.finished
	
	await get_tree().create_timer(durasi).timeout
