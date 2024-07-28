class_name State
extends Node

signal initialized
signal entered
signal exited
signal transitioned

var timer: float = 0.0


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
