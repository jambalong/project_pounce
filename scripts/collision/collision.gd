class_name Collision
extends Node

static func ray(from:Vector2, to:Vector2, world:World2D):
	var space = world.direct_space_state;
	var query = PhysicsRayQueryParameters2D.create(from, to)
	return space.intersect_ray(query);


static func point(point:Vector2, world:World2D):
	var space = world.direct_space_state;
	var query = PhysicsPointQueryParameters2D.new()
	query.position = point;
	return space.intersect_point(query);
