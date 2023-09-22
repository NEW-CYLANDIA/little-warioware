extends TextureRect

export var index: int


func _ready() -> void:
	if Session.game_state.lives < index + 1:
		modulate.v = 0.1
