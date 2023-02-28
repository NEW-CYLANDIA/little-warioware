extends Node2D
tool
export(NodePath) var sprite_path;
onready var sprite:Sprite = get_node(sprite_path);


export(NodePath) var tilemap_path;
onready var tilemap:TileMap = get_node(tilemap_path);

export var parse_sprite = false setget do_parse_sprite;

func _ready() -> void:
	pass # Replace with function body.
	
func do_parse_sprite(val:bool):
	sprite = get_node(sprite_path);
	tilemap = get_node(tilemap_path);
	var tex = sprite.texture.get_data();
	tex.lock();
	for x in tex.get_width():
		for y in tex.get_height():
			var pix = tex.get_pixel(x, y);
			var tile_color = pix.to_html(true).to_upper();
			if (!tile_color.begins_with("0")):
				tilemap.set_cell(x, y, tilemap.tile_set.find_tile_by_name(tile_color));
