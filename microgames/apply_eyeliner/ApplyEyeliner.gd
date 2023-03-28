extends Microgame

# Apply the eyeliner on the waterline!
onready var liner_area : Area2D = $Eye/Area2D
onready var is_in_eyeliner : Label = $Debug/IsInEyeliner
onready var is_applying : Label = $Debug/IsApplying
onready var is_started_label : Label = $Debug/IsStarted
onready var mouse_pos : Label = $Debug/MousePosition
onready var liner : KinematicBody2D = $Liner
onready var eye : Sprite = $Eye
onready var instructions : AnimatedSprite = $Instructions/AnimatedSprite
var is_started : bool = false
var is_in_liner_area : bool = false
var is_game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	instructions.play("default")
	pass

func fail():
	instructions.show()
	is_success = false
	
func success():
	instructions.show()
	is_success = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_applying.text = "IsApplying: %s" % Input.is_action_pressed("mg_mouse1")
	mouse_pos.text = "MousePos: %s" % get_viewport().get_mouse_position()
	if Input.is_action_pressed("mg_mouse1"):
		instructions.hide()
		is_started = true
	is_started_label.text = "IsStarted: %s" % is_started
	
	# Win/loss logic
	if is_started and get_viewport().get_mouse_position().x > 589 and Input.is_action_pressed("mg_mouse1") and is_in_liner_area:
		success()
	elif is_started and Input.is_action_just_released("mg_mouse1") and get_viewport().get_mouse_position().x < 589 and !is_in_liner_area:
		fail()
		
	# instructions animation control
	if is_success == true:
		instructions.play("slay")
	elif is_started == false:
		instructions.play("default")
	elif is_success == false:
		instructions.play("nay")


func on_enter(body):
	is_in_eyeliner.text = "IsInEyeliner: %s" % true
	is_in_liner_area = true

func on_exit(body):
	is_in_eyeliner.text = "IsInEyeliner: %s" % false
	is_in_liner_area = false
