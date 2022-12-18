extends TextureRect

export (int) var index


func _ready():
	if Global.current_session.lives < index + 1:
		modulate.v = 0.1
