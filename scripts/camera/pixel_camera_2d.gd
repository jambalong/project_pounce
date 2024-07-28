class_name PixelCamera2D
extends Camera2D

@export var smooth: float = 10.0
@export var integer_values: bool = true
@export var target_node: Node2D

@onready var camera_position: Vector2 = global_position
@onready var window_scale: float = (Vector2(DisplayServer.window_get_size()) / PixelPerfect2D.game_size).x


func _physics_process(delta: float) -> void:
	if is_instance_valid(target_node):
		camera_position = lerp(camera_position, target_node.global_position, delta * smooth) as Vector2
		var _subpixel_position: Vector2 = camera_position.round() - camera_position
		var _offset: Vector2 = Vector2(fmod(camera_position.x, 1.0), fmod(camera_position.y, 1.0))
		
		if integer_values:
			(PixelPerfect2D.pixel_perfect_viewport_container.material as ShaderMaterial).set_shader_parameter("camera_offset", _offset)
		
		global_position = camera_position.round() if integer_values else camera_position
