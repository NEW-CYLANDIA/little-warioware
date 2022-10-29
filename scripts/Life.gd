extends TextureRect

export (int) var index


func _ready():
	if Session.lives < index + 1:
		modulate.v = 0.1