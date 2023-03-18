extends Microgame

# Apply the eyeliner on the waterline!
onready var liner_area : Area2D = $Eye/Area2D
onready var liner : KinematicBody2D = $Liner
onready var eye : Sprite = $Eye
var is_started : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("mg_mouse1"):
		is_started = true
	if is_started and Input.is_action_just_released("mg_mouse1"):
		is_success = false

func on_exit():
	if get_viewport().get_mouse_position().x > 589:
		is_success = true
	else:
		is_success = false
