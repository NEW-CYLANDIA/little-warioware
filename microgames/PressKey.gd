extends Microgame
# A simple example microgame - press the key to win!
# ...or maybe not - it gets tricky on harder levels! 


onready var press_sprite : AnimatedSprite = $Instructions/AnimatedSprite

var velocity : Vector2


func _ready():
	randomize()
	velocity = Vector2(rand_range(-1,1), rand_range(-1,1)) * 500

	# if difficulty medium or hard, chance to flip win condition
	if session.level > Global.difficulty.EASY and randf() > 0.4:
		win_by_default = true
		is_success = true
		press_sprite.animation = "dont_press"


func _physics_process(delta):
	# on hard difficulty, move instructions randomly
	if session.level == Global.difficulty.HARD:
		var collision = $Instructions.move_and_collide(velocity * delta)

		if collision:
			velocity = velocity.bounce(collision.normal)


func _input(event):
	if event.is_action_pressed("action"):
		if win_by_default:
			is_success = false
			press_sprite.animation = "lose"
			$LoseSFX.play()
		else:
			is_success = true
			press_sprite.animation = "win"
			$WinSFX.play()			
