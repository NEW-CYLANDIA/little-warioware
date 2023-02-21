extends Resource
class_name GameMode


enum difficulty { EASY = 1, MEDIUM = 2, HARD = 3 }


export var name : String
export var starting_lives : int
export(difficulty) var starting_level : int
export var starting_speed : int
export var level_up_interval : int
export var speed_up_interval : int
