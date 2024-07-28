class_name CameraShake
extends Node2D

@export_exp_easing("attenuation") var damp := 1.0

@onready var camera := get_parent() as Camera2D

var amplitude := Vector2(6.0, 6.0)
var duration := 5
var offset := Vector2.ZERO
var time_left := 0.0


func _ready() -> void:
	randomize()
	set_process(false)


func _physics_process(delta: float) -> void:
	if camera:
		if time_left > 0:
			time_left -= delta
			
			var ease_off = ease(time_left / duration, damp)
			offset = Vector2(randf_range(-amplitude.x, amplitude.x), randf_range(-amplitude.y, amplitude.y)) * ease_off
			camera.offset = offset
