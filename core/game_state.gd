extends Resource
class_name GameState

enum Difficulty { EASY = 1, MEDIUM = 2, HARD = 3 }

export var name: String
export var lives: int = 4
export(Difficulty) var level: int = Difficulty.EASY
export var speed: float = 1
export var level_up_interval: int = 10
export var speed_up_interval: int = 3

var current_score : int = 0