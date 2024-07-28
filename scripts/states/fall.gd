extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player: Player = $"../.." as Player


func enter() -> void:
	animation_player.play("fall")
	
	player.landed.connect(func(_velocity_y):
		transitioned.emit(self, "idle")
	)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if player.is_wall_sliding:
		transitioned.emit(self, "slide")
