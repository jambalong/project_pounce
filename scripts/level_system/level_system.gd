extends Node2D

signal level_changed(level_name)

@export var level_name: String

func _on_next_level_body_entered(body):
	if body.is_in_group("player"):
		level_changed.emit(level_name)
