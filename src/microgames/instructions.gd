extends Timer
class_name Instructions

onready var prompt: Label = $Prompt as Label


func _ready() -> void:
	prompt.hide()


func show(prompt_text: String, time: float = 1.0) -> void:
	wait_time = time

	prompt.text = prompt_text
	prompt.show()

	start()

	yield(self, "timeout")
	($FadeOutAnim as AnimationPlayer).play("FadeOut")
