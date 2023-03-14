extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var dir:Vector2;

export(NodePath) var img_tilemap_path:String
onready var img_tilemap:TileMap = get_node(img_tilemap_path);

export var color:int;

export var pixels_to_draw = 3;

export var move_interval = 0.5;

var pixels_drawn = 0;

var cell_size = 16;

var target = Vector2();

signal drawing_done(is_correct);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = position;
		
	#$Sprite.modulate = img_tilemap.tile_set.tile_get_name(correct_choice);
	
func _process(delta: float) -> void:
	position = position.linear_interpolate(target, 0.2);
	$Sprite.scale = $Sprite.scale.linear_interpolate(Vector2.ONE, 0.1);

func get_tile_under_pos(pos) -> int:
	var tile_pos = world_to_tilemap_pos(pos);
	return img_tilemap.get_cellv(tile_pos);
	
func world_to_tilemap_pos(pos):
	return img_tilemap.world_to_map(img_tilemap.to_local(pos));
func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("mg_action")):
		
		var tile_under_pencil = get_tile_under_pos(target);
		var tile_name = img_tilemap.tile_set.tile_get_name(tile_under_pencil);
		if (tile_name == "00000000"):
			$PixelPlaceSfx.play();
			$Sprite.frame = 0;
			$Fx.frame = 0;
			$Sprite.play("press")
			$Fx.play("fx");
			img_tilemap.set_cellv(world_to_tilemap_pos(target), color)
			
			pixels_drawn += 1;
			if (pixels_drawn >= pixels_to_draw):
				yield(get_tree().create_timer(0.2), "timeout")
				visible = false;
				emit_signal("drawing_done", true);
		else:
			$WrongPixelPlaceSfx.play();
			
	dir = Vector2.ZERO;
	if (event.is_action_pressed("mg_left")): dir = Vector2.LEFT
	if (event.is_action_pressed("mg_right")): dir = Vector2.RIGHT
	if (event.is_action_pressed("mg_up")): dir = Vector2.UP
	if (event.is_action_pressed("mg_down")): dir = Vector2.DOWN
	target += dir * cell_size;
	
