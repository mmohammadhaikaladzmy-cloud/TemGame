extends Control

# Referensi Node UI
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var story_label: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var play_button: TextureButton = $CanvasLayer/CenterMenu/PlayButton
@onready var continue_prompt: Label = $CanvasLayer/ContinuePrompt

# Referensi Tombol Tambahan (BottomLeftMenu)
@onready var exit_button: TextureButton = $CanvasLayer/BottomLeftMenu/ExitButton
@onready var info_button: TextureButton = $CanvasLayer/BottomLeftMenu/InfoButton

# Referensi Audio
@onready var click_sfx: AudioStreamPlayer = $CanvasLayer/ClickSFX
@onready var bgm_player: AudioStreamPlayer = $AudioStreamPlayer

# Variabel Kontrol
var is_typing: bool = false
var is_waiting_input: bool = false
var tween_ketik: Tween
var prompt_tween: Tween
var custom_info_panel: Control = null

func _ready() -> void:
	# PAKSA COLORRECT MENJADI FULLSCREEN
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.size = get_viewport_rect().size
	
	# Transparansi awal
	color_rect.color.a = 0.0
	story_label.modulate.a = 0.0
	story_label.visible_ratio = 0.0
	
	play_button.disabled = false
	
	if continue_prompt:
		continue_prompt.modulate.a = 0.0

	_create_custom_info_panel()

	if not play_button.pressed.is_connected(_on_play_button_pressed):
		play_button.pressed.connect(_on_play_button_pressed)
		
	if exit_button and not exit_button.pressed.is_connected(_on_exit_button_pressed):
		exit_button.pressed.connect(_on_exit_button_pressed)
		
	if info_button and not info_button.pressed.is_connected(_on_info_button_pressed):
		info_button.pressed.connect(_on_info_button_pressed)

	_setup_button_effects(play_button)
	if exit_button:
		_setup_button_effects(exit_button)
	if info_button:
		_setup_button_effects(info_button)

func _setup_button_effects(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2
	btn.button_down.connect(func(): create_tween().tween_property(btn, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT))
	btn.button_up.connect(func(): create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT))
	btn.mouse_entered.connect(func(): btn.pivot_offset = btn.size / 2; create_tween().tween_property(btn, "scale", Vector2(1.08, 1.08), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT))
	btn.mouse_exited.connect(func(): create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT))

func _create_custom_info_panel() -> void:
	custom_info_panel = Control.new()
	custom_info_panel.name = "CustomInfoPanel"
	custom_info_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	custom_info_panel.visible = false

	var bg_overlay = ColorRect.new()
	bg_overlay.color = Color(0, 0, 0, 0.85)
	bg_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	custom_info_panel.add_child(bg_overlay)

	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	custom_info_panel.add_child(center_container)

	var box = PanelContainer.new()
	box.custom_minimum_size = Vector2(500, 360)
	center_container.add_child(box)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	box.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	margin.add_child(vbox)

	var gold_color = Color("9f7d1dff")

	var title = Label.new()
	title.text = "INFORMASI GAME"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", gold_color)
	vbox.add_child(title)

	var info_text = Label.new()
	info_text.text = "Judul: Gaok Ireng\nDeveloper: Yummy Nobo \nGaok Ireng adalah game yang mengajak kita berpetualang bersama gadis SMA bernama Rara. Rara harus mencari ke-3 pusaka sakti keluarganya karena dia adalah bagian utama dari keluarga Gaok, keluarga dukun tersakti di Nusantara. Keluarga Gaok runtuh dalam semalam karena melanggar perjanjian dan Rara harus mencari kembali ke-3 pusaka tersebut agar bisa menentukan pilihan. Dikarenakan setiap malam satu suro akan ada penumbalan dari anggota keluarga Gaok. Dan malam satu suro hanya tersisa 29 hari lagi.\n\nPerjalanan ini akan berujung pada satu keputusan berat yang harus kita ambil: memutus rantai tumbal berdarah itu untuk selamanya, atau kembali menghidupkan perjanjian kelam demi merengkuh kejayaan masa lalu. \nFrom: SMK Telekomunikasi Tunas Harapan\n"
	info_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	info_text.custom_minimum_size = Vector2(440, 0)
	info_text.add_theme_color_override("font_color", gold_color.lightened(0.1))
	vbox.add_child(info_text)

	var close_btn = Button.new()
	close_btn.text = "TUTUP"
	close_btn.custom_minimum_size = Vector2(120, 38)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.add_theme_color_override("font_color", Color.BLACK)
	
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = gold_color
	btn_style.corner_radius_top_left = 6
	btn_style.corner_radius_top_right = 6
	btn_style.corner_radius_bottom_left = 6
	btn_style.corner_radius_bottom_right = 6
	close_btn.add_theme_stylebox_override("normal", btn_style)
	close_btn.add_theme_stylebox_override("hover", btn_style)
	close_btn.add_theme_stylebox_override("pressed", btn_style)
	
	close_btn.pressed.connect(_on_close_info_pressed)
	vbox.add_child(close_btn)

	$CanvasLayer.add_child(custom_info_panel)

func _on_exit_button_pressed() -> void:
	play_sfx_custom(0.8, 1.0)
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()

func _on_info_button_pressed() -> void:
	play_sfx_custom(0.8, 1.0)
	if custom_info_panel:
		custom_info_panel.visible = true

func _on_close_info_pressed() -> void:
	play_sfx_custom(0.8, 1.0)
	if custom_info_panel:
		custom_info_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	var is_click = (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
	var is_space = (event is InputEventKey and event.pressed and event.keycode == KEY_SPACE)
	
	if is_click or is_space:
		if is_typing:
			if tween_ketik and tween_ketik.is_valid():
				tween_ketik.kill()
			story_label.visible_ratio = 1.0
			is_typing = false
		elif is_waiting_input:
			is_waiting_input = false

func play_sfx_custom(start_time: float, duration: float) -> void:
	if click_sfx:
		click_sfx.play(start_time)
		await get_tree().create_timer(duration).timeout
		click_sfx.stop()

func _on_play_button_pressed() -> void:
	play_button.disabled = true
	play_sfx_custom(0.8, 1.0)

	# 1. Layar Hitam Fullscreen & Fade Out Lagu
	var tween_hitam = create_tween().set_parallel(true)
	tween_hitam.tween_property(color_rect, "color:a", 1.0, 0.8)
	
	if bgm_player:
		tween_hitam.tween_property(bgm_player, "volume_db", -20.0, 0.8)
		
	await tween_hitam.finished

	# 2. MUNCULKAN TEKS CERITA INTRO
	story_label.modulate.a = 1.0
	story_label.visible_ratio = 0.0
	
	is_typing = true
	var total_kata = story_label.text.split(" ", false).size()
	var durasi_ketik = max(3.0, total_kata / 3.0)

	tween_ketik = create_tween()
	tween_ketik.tween_property(story_label, "visible_ratio", 1.0, durasi_ketik)
	
	while is_typing and story_label.visible_ratio < 1.0:
		await get_tree().process_frame
	
	is_typing = false

	# 3. Tampilkan Continue Prompt
	if continue_prompt:
		prompt_tween = create_tween().set_loops()
		prompt_tween.tween_property(continue_prompt, "modulate:a", 1.0, 0.8)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		prompt_tween.tween_property(continue_prompt, "modulate:a", 0.2, 0.8)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await get_tree().create_timer(0.2).timeout

	# 4. Tunggu Input Pemain
	is_waiting_input = true
	while is_waiting_input:
		await get_tree().process_frame

	if prompt_tween and prompt_tween.is_valid():
		prompt_tween.kill()

	# 5. Transition Keluar
	var tween_keluar = create_tween().set_parallel(true)
	tween_keluar.tween_property(story_label, "modulate:a", 0.0, 0.8)
	tween_keluar.tween_property(color_rect, "color:a", 1.0, 0.8)
	if continue_prompt:
		tween_keluar.tween_property(continue_prompt, "modulate:a", 0.0, 0.8)
	
	if bgm_player:
		tween_keluar.tween_property(bgm_player, "volume_db", -80.0, 0.8)
	
	await tween_keluar.finished

	# 6. PINDAH KE SCENE RUMAH AWAL (Pastikan path file tscn kamu sesuai di FileSystem)
	# Mengacu pada nama tab scene kamu: "Rumah-Awal.tscn"
	get_tree().change_scene_to_file("res://Rumah-Awal.tscn")
