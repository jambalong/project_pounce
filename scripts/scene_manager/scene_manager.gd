@tool
class_name SceneManager
extends Node

@export var main_nodes: Array[Node]
@export var game_view: Node
@export var transition_node: Node


func _enter_tree() -> void:
	check()


func _ready() -> void:
	if not Engine.is_editor_hint():
		add_to_group("scene_manager")
	get_tree().node_removed.connect(check)


static func change(_scene_path: String):
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
