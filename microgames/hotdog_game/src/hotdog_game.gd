extends Microgame

var hotdog_collected := false

func _ready():
	if is_difficulty_hard():
		$hotdog.FALL_SPEED = 20

func _physics_process(_delta):
	if is_timer_running:
		$hotdog.start_fall()
	if hotdog_collected:
		#hotdog moves with hand
		$hotdog.global_position = $hand/hotdog_marker.global_position

func _on_bun_collision_area_entered(area):
	if area.name == "hotdog_collision":
		$hotdog.stop_fall()
		$hotdog/falling.stop()
		hotdog_collected = true
		if not is_difficulty_easy():
			#if medium or hard, ketchup falls
			$ketchup.start_fall()
			$ketchup/falling.play()
		elif is_difficulty_easy():
		#if difficulty is easy, hotdog wins and ketchup and mustard dont fall
			is_success = true
	if area.name == "ketchup_collision":
		$ketchup.queue_free()
		$hotdog.play("ketchup")
		if is_difficulty_hard():
			$mustard.start_fall()
			$mustard/falling.play()
		else:
			#if difficulty is medium, ketchup and hotdog wins and mustard doesnt fall
			is_success = true
	if area.name == "mustard_collision":
		#if mustard falls and is caught, always win
		$mustard.queue_free()
		$hotdog.play("mustard")
		is_success = true
