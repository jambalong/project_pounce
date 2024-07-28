extends CPUParticles2D

@onready var remaining_time: float = lifetime
# Called every frame. `delta` is the elapsed time

func _ready() -> void:
	emitting = 1


func _process(delta: float) -> void:
	remaining_time -= delta
	if remaining_time < 0:
		queue_free()
