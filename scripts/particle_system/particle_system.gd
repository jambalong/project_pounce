class_name ParticleSystem
extends Node


static func create(parent: Node, particle: PackedScene, position: Vector2, count: int = 8) -> CPUParticles2D:
	var instance := particle.instantiate() as CPUParticles2D
	instance.amount = count
	parent.add_child(instance)
	instance.global_position = position
	return instance
