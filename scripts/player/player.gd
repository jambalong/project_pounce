class_name Player
extends CharacterPlatformer

@onready var player: Player = $"../.." as Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dash_effects: SubViewport = $DashEffect/DashEffects
@onready var dash_effect = preload("res://scenes/dash_effect.tscn")
@onready var dash_particles: CPUParticles2D = $DashParticles
@onready var shock_wave: ShockWave = get_tree().get_first_node_in_group("shock_wave") as ShockWave


var squish: Vector2 = Vector2(1, 1)
var character_direction: int = 1
var sprite_scale: Vector2 = Vector2(1, 1)
var dash_start_position: Vector2
var dash_effect_count: int = 3



func _ready() -> void:
	# Squish effect when character jumps
	jumped.connect(_squish_on_jump)

	# Squish effect when character lands
	landed.connect(_squish_on_land)


func _physics_process(delta) -> void:
	if shock_wave == null:
		shock_wave = get_tree().get_first_node_in_group("shock_wave") as ShockWave
	
	var player_input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# Squish effect
	squish = squish.slerp(Vector2(1, 1), 0.2)

	# Handle player direction
	character_velocity.x = player_input.x
	if character_velocity.x != 0:
		character_direction = sign(character_velocity.x)

	sprite_scale.x = character_direction
	animated_sprite.scale = sprite_scale * squish

	# Handle player jump
	if Input.is_action_just_pressed("jump"):
		jump()
	elif Input.is_action_just_released("jump"):
		release_jump()

	# Handle player dash
	if Input.is_action_just_pressed("dash") and can_dash():
		# Dash in the direction player is facing while there is no input
		var direction = Vector2(character_direction, 0) if player_input == Vector2.ZERO else player_input
		
		# Camera shake
		PixelPerfect2D.shake(direction * 1, 0.15)
		# Particle direction
		dash_particles.direction = direction
		
		# Activate dash
		dash(direction.angle())

		# Juice
		squish.x = 1.4
		squish.y = 0.4
		dash_start_position = global_position
		
		# Amount of sprites to drop when dashin
		dash_effect_count = 3
		
		# Shockwave effect
		shock_wave.create(global_position, 0.25, 3, 0, 1, 0.1)

		# Freeze frame effect
		OS.delay_msec(35)
	
	# Dash particles
	dash_particles.emitting = dash_is_active
	
	if dash_is_active:
		# Every time you advance 16 pixels, create a ghost effect
		var mod = round(dash_start_position.distance_to(global_position))
		
		if mod > 16 and dash_effect_count > 0:
			var instance = dash_effect.instantiate()
			var instance_sprite := instance.get_node("AnimatedSprite2D") as AnimatedSprite2D
			
			dash_effects.add_child(instance)
			instance.global_position = global_position + Vector2()
			dash_start_position = global_position
			instance_sprite.animation = animated_sprite.animation
			instance_sprite.frame = animated_sprite.frame
			dash_effect_count -= 1

	# Custom player physics process
	_custom_physics_process(delta)


## (FOR DEBUG) ALLOWS IT TO BE RENDERED THERE WHEN YOU CLICK WITH THE MOUSE.
func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event is InputEventMouseButton && event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
			velocity.y = 0;
			global_position = get_global_mouse_position()

func _custom_physics_process(delta):
	super._physics_process(delta)


func _squish_on_jump(_is_coyote_jump, _is_buffered, is_wall_jump):
	if is_wall_jump:
		squish.x = 0.8
		squish.y = 1.1
	else:
		squish.x = 0.6
		squish.y = 1.4


func _squish_on_land(_velocity_y):
	squish.x = 1.4
	squish.y = 0.6
