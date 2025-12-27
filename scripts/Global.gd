extends Node

const DEFAULT_FADE_TIME: float = 4.0


enum GameColor {
	NEUTRAL, # White
	YELLOW,
	GREEN,
	BLUE,
	PURPLE,
	RED,
	BROWN,
	BLACK
}

var selected_level_path: String = "res://levels/level1.json"

const COLOR_NAME_MAP = {
	"neutral": GameColor.NEUTRAL,
	"white": GameColor.NEUTRAL,
	"yellow": GameColor.YELLOW,
	"green": GameColor.GREEN,
	"blue": GameColor.BLUE,
	"purple": GameColor.PURPLE,
	"red": GameColor.RED,
	"brown": GameColor.BROWN,
	"black": GameColor.BLACK
}

const COLOR_VALUES = {
	GameColor.NEUTRAL: Color.WHITE,
	GameColor.YELLOW: Color.YELLOW,
	GameColor.GREEN: Color.GREEN,
	GameColor.BLUE: Color.BLUE,
	GameColor.PURPLE: Color.PURPLE,
	GameColor.RED: Color.RED,
	GameColor.BROWN: Color.SADDLE_BROWN,
	GameColor.BLACK: Color.BLACK
}

func get_color_from_name(color_name: String) -> GameColor:
	return COLOR_NAME_MAP.get(color_name.to_lower(), GameColor.NEUTRAL)

const COLOR_ORDER = [
	GameColor.YELLOW,
	GameColor.GREEN,
	GameColor.BLUE,
	GameColor.PURPLE,
	GameColor.RED,
	GameColor.BROWN,
	GameColor.BLACK
]

func get_color_order(color: GameColor) -> int:
	if color == GameColor.NEUTRAL:
		return -1
	return COLOR_ORDER.find(color)

func get_next_color(current: GameColor) -> GameColor:
	var order = get_color_order(current)
	if order == -1 or order == COLOR_ORDER.size() - 1:
		return COLOR_ORDER[0]
	return COLOR_ORDER[order + 1]

func get_color_value(color: GameColor) -> Color:
	return COLOR_VALUES.get(color, Color.WHITE)
