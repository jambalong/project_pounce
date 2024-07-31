class_name PixelPerfectContainer
extends SubViewportContainer

@onready var _sub_viewport = $PixelPerfectViewport


func _ready() -> void:
	PixelPerfect2D.pixel_perfect_viewport_container = self
	PixelPerfect2D.pixel_perfect_viewport = $PixelPerfectViewport
	update_canvas()


func update_canvas() -> void:
	var viewport_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	var shrink_scale = viewport_size.x / PixelPerfect2D.game_size.x
	
	_sub_viewport.set_owner(get_tree().edited_scene_root)
	_sub_viewport.name = "PixelPerfectViewport"
	#_sub_viewport.size = PixelPerfect2D.game_size + Vector2(2, 2)
	_sub_viewport.disable_3d = true
	_sub_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	
	set_owner(get_tree().edited_scene_root)
	name = "PixelPerfectContainer"
	stretch = true
	stretch_shrink = shrink_scale
	#layout_mode = 1
	
	set_anchors_preset(Control.PRESET_FULL_RECT)
	#size = viewport_size + Vector2(2, 2) * shrink_scale
	#position -= Vector2(1, 1) * shrink_scale
	set_script(preload("res://scripts/camera/pixel_perfect_container.gd"))
	
	var camera_material: ShaderMaterial = ShaderMaterial.new()
	camera_material.shader = preload("res://shaders/smooth_camera.gdshader")
	material = camera_material
