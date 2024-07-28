extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player: Player = $"../.." as Player


func enter() -> void:
	animation_player.play("slide")


func exit() -> void:
	pass


func update(_delta:float) -> void:
	if timer < 0.5 and fmod(timer, _delta) <= _delta * 0.75:
		ParticleSystem.create(player.get_parent(), preload("res://scenes/dust.tscn"), player.global_position + Vector2(4 * player._last_turned_direction, 2))


func physics_update(_delta:float) -> void:
	if not player.on_wall || player.on_floor:
		transitioned.emit(self, "idle")
