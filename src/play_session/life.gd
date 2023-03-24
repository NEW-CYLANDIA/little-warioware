extends TextureRect

export var index: int


func _ready() -> void:
	if Global.current_session.lives < index + 1:
		modulate.v = 0.1
