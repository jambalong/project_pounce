@tool
class_name PixelViewportDrawing
extends Node2D

@export var line_color: Color = Color("00ffff65")
@export var line_width: float = 1.0

func _set_line_color(value: Color) -> void:
	line_color = value
	queue_redraw()


func _set_line_width(value: float) -> void:
	line_width = value
	queue_redraw()

func _ready() -> void:
	z_index = 100
	if not Engine.is_editor_hint():
		queue_free()


func _draw() -> void:
	draw_rect(Rect2(0, 0, PixelPerfect2D.game_size.x, PixelPerfect2D.game_size.y), line_color, false, line_width)
