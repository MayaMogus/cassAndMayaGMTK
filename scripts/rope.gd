extends RigidBody2D

var pointA
var pointB
var pivot = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var local_a = $Line2D.to_local(pointA.global_position)
	var local_b = $Line2D.to_local(pointB.global_position)
	$Line2D.points = [local_a, local_b]
	if pivot != null:
		global_position = pivot.global_position

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	print(pointA,'  ',pointB)
	print(pointA.global_position,'  ',pointB.global_position )
