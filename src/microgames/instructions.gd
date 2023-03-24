extends Label

export var lifetime: float = 1
signal instructions_shown


func _ready() -> void:
	$Timer.start(lifetime)


func _on_Timer_timeout() -> void:
	$FadeOutAnim.play("FadeOut")
	emit_signal("instructions_shown")
	yield($FadeOutAnim, "animation_finished")
	queue_free()
