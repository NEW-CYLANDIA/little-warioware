extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var dir:Vector2;

export(NodePath) var img_tilemap_path:String
onready var img_tilemap:TileMap = get_node(img_tilemap_path);

## This is an array of indexes into the image tilemap.
export(Array, int) var tilemap_color_choices;

export var correct_choice:int;

var color_choices:Array;

var cell_size = 16;
var move_interval = 0.5;
var target = Vector2();

var color_index = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = position;
	$Timer.start(move_interval)
	for c in tilemap_color_choices:
		color_choices.push_back(Color(img_tilemap.tile_set.tile_get_name(c)))
		
	$Sprite.modulate = color_choices[color_index];
	
func _process(delta: float) -> void:
	position = position.linear_interpolate(target, 0.2);

func get_tile_under_pencil(pos) -> int:
	var tile_pos = world_to_tilemap_pos(pos);
	return img_tilemap.get_cellv(tile_pos);
	
func world_to_tilemap_pos(pos):
	return img_tilemap.world_to_map(img_tilemap.to_local(pos));
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("mg_action")):
		color_index += 1;
		if (color_index > 2):
			color_index = 0;
		$Sprite.modulate = color_choices[color_index];


func _on_Timer_timeout() -> void:
	target += dir * cell_size;
	var tile_under_pencil = get_tile_under_pencil(target);
	print(tile_under_pencil);
	if (tile_under_pencil == -1):
		$Sprite.frame = 0;
		$Fx.frame = 0;
		$Sprite.play("press")
		$Fx.play("fx");
		img_tilemap.set_cellv(world_to_tilemap_pos(target), tilemap_color_choices[color_index])
	$Timer.start(move_interval)
	
