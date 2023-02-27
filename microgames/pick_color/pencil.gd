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

export var pixels_to_draw = 3;

export var move_interval = 0.5;

var pixels_drawn = 0;

var picked_correct_color = true;

var color_choices:Array;

var cell_size = 16;

var target = Vector2();

var color_index = 0;

signal drawing_done(is_correct);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = position;
	$Timer.start(move_interval)
	for c in tilemap_color_choices:
		color_choices.push_back(Color(img_tilemap.tile_set.tile_get_name(c)))
		
	$Sprite.modulate = color_choices[color_index];
	
func _process(delta: float) -> void:
	position = position.linear_interpolate(target, 0.2);
	$Sprite.scale = $Sprite.scale.linear_interpolate(Vector2.ONE, 0.1);

func get_tile_under_pos(pos) -> int:
	var tile_pos = world_to_tilemap_pos(pos);
	return img_tilemap.get_cellv(tile_pos);
	
func world_to_tilemap_pos(pos):
	return img_tilemap.world_to_map(img_tilemap.to_local(pos));
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("mg_action") && get_tile_under_pos(target) != -1):
		color_index += 1;
		if (color_index > color_choices.size()-1):
			color_index = 0;
		$Sprite.scale = Vector2.ONE * 1.5;
		$Sprite.modulate = color_choices[color_index];


func _on_Timer_timeout() -> void:
	target += dir * cell_size;
	var tile_under_pencil = get_tile_under_pos(target);
	print(tile_under_pencil);
	if (tile_under_pencil == -1):

		$Sprite.frame = 0;
		$Fx.frame = 0;
		$Sprite.play("press")
		$Fx.play("fx");
		var color_chosen = tilemap_color_choices[color_index];
		if (color_chosen != correct_choice):
			picked_correct_color = false;
		img_tilemap.set_cellv(world_to_tilemap_pos(target), color_chosen)
		
		pixels_drawn += 1;
		if (pixels_drawn >= pixels_to_draw):
			emit_signal("drawing_done", picked_correct_color);
			print("drawing done! picked right color: " + str(picked_correct_color));
				
	$Timer.start(move_interval)
	
