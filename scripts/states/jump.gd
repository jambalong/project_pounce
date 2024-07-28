extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player: Player = $"../.." as Player

func enter() -> void:
	animation_player.play("jump")
	
	# Fall
	player.falling.connect(func():
		transitioned.emit(self, "fall")
	)
	
	ParticleSystem.create(player.get_parent(), preload("res://scenes/dust.tscn"), player.global_position + Vector2(0, 0));


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if player.is_wall_sliding:
		transitioned.emit(self, "slide")
