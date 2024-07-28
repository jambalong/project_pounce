extends State

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player: Player = $"../.." as Player


func enter() -> void:
	animation_player.play("run")
	
	# Jump
	player.jumped.connect(func(_is_coyote_jump, _is_buffered, _is_wall_jump):
		transitioned.emit(self, "jump")
	)
	
	# Fall
	player.falling.connect(func():
		transitioned.emit(self, "fall")
	)


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if abs(player.velocity.x * _delta) < 0.25:
		transitioned.emit(self, "idle")
