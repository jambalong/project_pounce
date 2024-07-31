@tool
class_name SceneManager
extends Node

@export var main_nodes: Array[Node]
@export var game_view: Node
@export var transition_node: Node

@onready var viewport = $GameView/PixelPerfectContainer/PixelPerfectViewport
@onready var current_level = $GameView/PixelPerfectContainer/PixelPerfectViewport/Game


func _enter_tree() -> void:
	check()


func _ready() -> void:
	if not Engine.is_editor_hint():
		add_to_group("scene_manager")
	get_tree().node_removed.connect(check)
	
	current_level.level_changed.connect(_handle_level_changed)


func _handle_level_changed(current_level_name: String):
	var next_level
	var next_level_number: int = current_level_name.to_int() + 1
	var level_system_path = "res://scenes/level_system/level_"
	
	var next_level_path = level_system_path + str(next_level_number) + ".tscn"
	
	next_level = load(next_level_path).instantiate()
	viewport.call_deferred("add_child", next_level)
	current_level.queue_free()
	current_level = next_level


static func change_scene(_scene_path: String):
	pass


func check(node: Node = null) -> void:
	if transition_node == node:
		transition_node = null
	
	var _transition = find_child("Transition")
	
	if _transition != null:
		if transition_node == null:
			transition_node = _transition
	else:
		if transition_node == null:
			var transition = Control.new()
			add_child.call_deferred(transition)
			transition.set_owner.call_deferred(self)
			transition.name = "Transition"
			transition_node = transition
