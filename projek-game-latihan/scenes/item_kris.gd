extends Area2D

@export var nama_pusaka: String = "Keris Mistis"
@export var gambar_gede: Texture2D

func _on_body_entered(body: Node2D) -> void:
	# Pastikan node karakter utamamu bernama "Player"
	if body.name == "Player":
		
		# 1. Sembunyikan keris kecil di map dan matikan deteksi agar tidak ke-trigger 2x
		$kris.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 2. Masukkan gambar besar dan teks ke UI Canvas
		%GambarPusaka.texture = gambar_gede
		%TeksPusaka.text = "Pusaka " + nama_pusaka + " telah didapatkan!"
		
		# 3. Munculkan UI ke layar
		%NotifPusaka.show()
		
		# 4. Tunggu 3 detik pakai timer bawaan Godot
		await get_tree().create_timer(3.0).timeout
		
		# 5. Sembunyikan UI kembali dan hapus data item dari game secara permanen
		%NotifPusaka.hide()
		queue_free()
