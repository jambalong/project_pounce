class_name PlatformerResource extends Resource

## Export Variables

@export_category("Main Variables")
# Character speed
@export var speed:float = 1.5
# Character acceleration curve
@export var acceleration: float = 0.25
# Character friction curve
@export var friction: float = 0.34
# Character turning speed
@export var turn_speed: float = 0.55

@export_category("Platformer Variables")
@export_group("Gravity Variables")
# Force exerted on character towards the ground
@export var gravity: float = 0.22
# Multiplier for gravity when character is falling
@export var fall_gravity: float = 0.8
# Multiplier for gravity when character is jumping
@export var jump_gravity: float = 0.8
# Maximum gravity force
@export var max_gravity: float = 6.0
# Gravity scale
@export var gravity_scale: float = 1.0

@export_group("On Air Variables")
# Air acceleration curve
@export var air_acceleration: float = 0.21
# Air control curve
@export var air_control: float = 0.5
# Air friction curve
@export var air_friction: float = 0.4

@export_group("Jump Variables")
# Jump height
@export var jump_height: float = 3.2
# Jump cutoff
@export var jump_cutoff: float = 2.0

@export_group("Wall Variables")
# Wall exists for wall jump
@export var wall_active: float = true
# Wall slide when moving towards wall
@export var wall_when_moving: float = true
# Gravity of wall slide
@export var wall_slide_gravity: float = 0.1
# Max gravity of wall slide
@export var wall_slide_max_gravity: float = 1.75
# Wall jump height
@export var wall_jump_height: float = 2.25
# Minimum wall jump height
@export var wall_jump_min_height: float = 1.5
# Wall jump offset
@export var wall_jump_offset: float = 3.0
# Minimum wall jump offset
@export var wall_jump_min_offset: float = 2.0
# Wall jump cooldown
@export var wall_jump_cooldown: float = 0.1
# Wall jump buffer
@export var wall_jump_buffer: float = 0.05
# Wall safe margin
@export var wall_safe_margin: float = 3.0

@export_group("Dash Variables")
# Dash strength
@export var dash_strength: float = 3.8
# Dash cooldown
@export var dash_cooldown: float = 0.15
# Dash scales
@export var dash_up_scale: float = 0.75
@export var dash_down_scale: float = 1.0
@export var dash_right_scale: float = 1.0
@export var dash_left_scale: float = 1.0
# Dash count
@export var dash_count: int = 1

@export_group("Game Feel Variables")
# Jump buffer
@export var jump_buffer: float = 0.1
# Coyote time
@export var coyote_time: float = 0.1
# Distance for checking edges
@export var edge_check_distance: float = 4.0
# Corner correction steps
@export var corner_correction_steps: float = 4.0
