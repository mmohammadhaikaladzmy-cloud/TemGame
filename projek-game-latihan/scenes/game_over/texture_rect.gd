extends ColorRect

@onready var AksJaw_txt = $AksaraJawa
@onready var RarDie_txt = $Rara_died
@onready var TryAgain = $Try_again
@onready var button_try = $Try_again/Button
@onready var button_giveup = $Try_again/Button2

func _ready() -> void:
	TryAgain.visible = false
	AksJaw_txt.visible = true
	RarDie_txt.visible = true
	
	await get_tree().create_timer(1).timeout
	
	AksJaw_txt.visible = false
	RarDie_txt.visible = false
	
	await get_tree().create_timer(2).timeout
	
	TryAgain.visible = true
