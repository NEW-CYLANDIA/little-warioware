extends Microgame # all microgames must extend the Microgame class!

# export vars appear in the inspector for fast tweaking
export(int) var easy_presses_required = 5
export(int) var medium_presses_required = 10
# default values are optional
export(int) var hard_presses_required

# variables can be type checked with ":"
var presses_required : int
# typing with ":" is optional, but recommended
var current_presses = 0 # : int

# type is inferred by value set
onready var label := $Label


# _ready() is called when the microgame starts
func _ready():
	# parent Microgame class has helper functions
	# is_level_*() will return true/false
	if is_level_easy():
		presses_required = easy_presses_required
	elif is_level_medium():
		presses_required = medium_presses_required
	# get_current_level() returns difficulty as a number/enum
	elif get_current_level() == GameState.Difficulty.HARD:
		presses_required = hard_presses_required


# _process() is called every frame
func _process(_delta):
	# on action button pressed, increment current press count
	if Input.is_action_just_pressed("mg_action"): # "mg_action" == Z key
		current_presses += 1

	# if press count meats the goal, you win!
	if _is_goal_met():
		is_success = true # this is reported back to the Session to determine win/loss
		$Label.text = "You did it!"
	else:
		# otherwise, update label to display progress
		label.text = "Press the Action key %s more times!" % (presses_required - current_presses)


# functions can have type checking for return values
func _is_goal_met() -> bool:
	return current_presses >= presses_required
