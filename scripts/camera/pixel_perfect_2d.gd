@tool
extends Node

# EDITABLE
var game_size: Vector2 = Vector2(320, 180)

## OTHER
var pixel_perfect_viewport_container: SubViewportContainer
var pixel_perfect_viewport: SubViewport


func shake(_amplitude: Vector2, _duration: float):
	var camera: Camera2D = pixel_perfect_viewport.get_camera_2d()
	
	if camera:
		for each_shake in camera.get_children():
			if each_shake is CameraShake:
				each_shake.duration = _duration
				each_shake.time_left = _duration
				each_shake.amplitude = _amplitude
