extends AudioStreamPlayer2D

func Play() -> void:
	play()

func Mute() -> void:
	volume_db = -80
	await get_tree().create_timer(2.5).timeout
	volume_db = 0
