extends Timer

onready var fade_out_anim : AnimationPlayer = $FadeOutAnim
onready var prompt : Label = $Prompt


func _on_timeout() -> void:
	fade_out_anim.play("FadeOut")
	yield(fade_out_anim, "animation_finished")
	queue_free()
