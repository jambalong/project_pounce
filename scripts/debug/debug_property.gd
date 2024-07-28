class_name DebugProperty
extends MarginContainer

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var player: Player = get_tree().get_first_node_in_group("player")

var debug = [
	["Coyote Time", func(): return player._remaining_coyote_time],
	["Jump Buffer", func(): return player._remaining_jump_buffer],
	["Gravity Multiplier", func(): return player._gravity_multiplier],
	["Is Falling", func(): return player.is_falling],
	["On Floor", func(): return player.on_floor],
	["On Ceiling", func(): return player.on_ceiling],
	["On Wall", func(): return player.on_wall],
	["Is Jumping", func(): return player.is_jumping],
	["Is Wall Sliding", func(): return player.is_wall_sliding],
	["Fall Velocity", func(): return player.fall_velocity * get_process_delta_time()],
	["Velocity X", func(): return player.velocity.x * get_process_delta_time()],
	["Velocity Y", func(): return player.velocity.y * get_process_delta_time()],
	["Move Cooldown X", func(): return player.move_cooldown.x],
	["Move Cooldown Y", func(): return player.move_cooldown.y],
	["On Edge", func(): return player.on_edge],
	["Dash Is Active", func(): return player.dash_is_active],
]

var debug_box = preload("res://scenes/debug_box.tscn")


func _ready() -> void:
	for i in debug:
		var instance = debug_box.instantiate()
		v_box_container.add_child(instance)
		instance.value_function = i[1]
		instance.get_node("Name").text = i[0]
