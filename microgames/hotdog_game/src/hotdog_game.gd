extends Microgame

var hotdog_collected := false

func _ready():
	session.level = Global.difficulty.HARD
	instructions.connect("timeout",self,"_on_Prompt_instructions_shown")
	# only drops hotdog after instructions are shown
	# if theres a baked in way of doing this w the microgame class, tell me
	if session.level == Global.difficulty.HARD:
		$hotdog.FALL_SPEED = 20

func _physics_process(_delta):
	if hotdog_collected:
		$hotdog.global_position = $hand/hotdog_marker.global_position

func _on_bun_collision_area_entered(area):
	if area.name == "hotdog_collision":
		$hotdog.falling = false
		hotdog_collected = true
		if not session.level == Global.difficulty.EASY:
			$ketchup.falling = true
			$ketchup/falling.play()
		else:
			is_success = true
	if area.name == "ketchup_collision":
		$ketchup.queue_free()
		$hotdog.play("ketchup")
		if session.level == Global.difficulty.HARD:
			$mustard.falling = true
			$mustard/falling.play()
		else:
			is_success = true
	if area.name == "mustard_collision":
		$mustard.queue_free()
		$hotdog.play("mustard")
		is_success = true
func _on_Prompt_instructions_shown() -> void:
	$hotdog.falling = true
	$hotdog/falling.play()
