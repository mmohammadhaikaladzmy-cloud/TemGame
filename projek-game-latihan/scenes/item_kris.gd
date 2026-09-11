extends Area2D

@export var nama_pusaka: String = "Keris Mistis"
@export var gambar_gede: Texture2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		
		# 1. Sembunyikan sprite anak pertama dan matikan collision area ini
		$CollisionShape2D.set_deferred("disabled", true)
		# Menyembunyikan sprite apapun yang ada di dalam item ini secara otomatis
		for child in get_children():
			if child is Sprite2D:
				child.hide()
		
		# 2. Masukkan gambar besar dan teks ke UI Canvas
		%GambarPusaka.texture = gambar_gede
		%TeksPusaka.text = "Pusaka " + nama_pusaka + " telah didapatkan!"
		
		# 3. Munculkan UI ke layar
		%NotifPusaka.show()
		
		# 4. Tunggu 3 detik
		await get_tree().create_timer(3.0).timeout
		
		# 5. Sembunyikan UI dan hapus item dari game
		%NotifPusaka.hide()
		queue_free()
