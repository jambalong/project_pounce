class_name GameView
extends Control

var shock_wave = ShockWave.new()
@onready var pixel_perfect_viewport: SubViewport = $PixelPerfectContainer/PixelPerfectViewport
@onready var game = $PixelPerfectContainer/PixelPerfectViewport/Game


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pixel_perfect_viewport.add_child(shock_wave)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 60
