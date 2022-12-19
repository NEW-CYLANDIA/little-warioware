extends Timer


func _process(_delta):
	$TimerDisplay/TextureProgress.value = get_time_left() / get_wait_time() * 100
