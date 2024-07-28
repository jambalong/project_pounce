class_name ShockWave
extends Control

@onready var shock_viewer: PackedScene = load("res://scenes/shock_wave/shock_wave_view_comp.tscn")
@onready var shock_effect: PackedScene = load("res://scenes/shock_wave/shock_effect.tscn")

var view: Control = null
var shock_view: SubViewport = null

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	name = "ShockWaveViewer"
	add_to_group("shock_wave")
	view = shock_viewer.instantiate()
	add_child(view)
	shock_view = view.get_node("SubViewport")
	get_viewport().size_changed.connect(update)
	update()


func update() -> void:
	size = get_viewport_rect().size
	shock_view.size = get_viewport_rect().size


func create(
	pos: Vector2, strength = null, speed = null,
	fade = null, duration = null, start_scale = null
) -> void:
	var instance = shock_effect.instantiate()
	instance.position = pos
	
	if strength != null:
		instance.strength = strength
	if speed != null:
		instance.speed = speed
	if duration != null:
		instance.duration = duration
	if start_scale != null:
		instance.start_scale = start_scale
	if fade != null:
		instance.fade = fade
	
	shock_view.add_child(instance)
