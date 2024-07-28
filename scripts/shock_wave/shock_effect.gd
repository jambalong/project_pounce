class_name ShockEffect
extends Sprite2D


var start_scale = 0.5
var speed: float = 1.0
var strength: float = 1.0
var duration: float = 1.0
var fade: float = 0.0


func _ready() -> void:
	scale = Vector2(start_scale * 0.25, start_scale * 0.25)
	modulate.a = strength


func _process(delta: float) -> void:
	scale *= 1.02 + (speed * delta)
	delta = 0.008
	
	if fade <= 0:
		modulate.a = lerp(modulate.a, 0.0, (1.0 / duration) * delta * speed * 5.0)
	else:
		fade -= delta
	
	if modulate.a < delta:
		queue_free()
