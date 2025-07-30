extends Node2D

var pointA
var pointB

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var local_a = $RigidBody2D/Line2D.to_local(pointA.global_position)
	var local_b = $RigidBody2D/Line2D.to_local(pointB.global_position)
	$RigidBody2D/Line2D.points = [local_a, local_b]
