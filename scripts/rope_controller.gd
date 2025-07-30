extends Node2D
@export var ropeScene : PackedScene

func attachRope(length, amount, pivot:StaticBody2D):
	var RopeUI :Label= $"../UI/Label"
	var player = $"../player".get_child(0)
	var prevRope : RigidBody2D
	var distanceToPlayer = pivot.global_position.distance_to(player.global_position)
	var toTheLeft : int = 1
	
	if pivot.global_position.x > player.global_position.x:
		toTheLeft = -1
	#print(toTheLeft)
	#print(pivot.global_position.x,'pibot pos')
	RopeUI.text = str('ROPE ATTACHED :' , amount)
	#print(pivot.name, 'pibot')
	for i in amount:
		var ropeSegment = ropeScene.instantiate()
		add_child(ropeSegment)
		ropeSegment.global_position = pivot.global_position
		#print(pivot.global_position.y)
		#print(distanceToPlayer, 'dosta')
		var Spring :PinJoint2D= ropeSegment.get_node('RigidBody2D/Spring')
		var Spring2 :PinJoint2D= ropeSegment.get_node('RigidBody2D/Spring2')
		var ropeBody : RigidBody2D = ropeSegment.get_node("RigidBody2D")
		
		var pointA
		var pointB
		Spring.node_b = ropeBody.get_path()
		pointB = ropeBody
		

		
		
		if i == 0:
			pointA = pivot
			Spring.node_a = pivot.get_path()
		if i != amount - 1 and i != 0:
			pointA = prevRope
			Spring.node_a = prevRope.get_path()
		if i == amount - 1:
			pointA = player
			Spring.node_a = player.get_path()
			print('RAHH')
			ropeSegment.global_position = player.global_position
			print()
			Spring2.node_a = ropeSegment.get_node("RigidBody2D").get_path()
			Spring2.node_b = prevRope.get_path()
			pointB = prevRope
		else:
			prevRope = ropeSegment.get_node('RigidBody2D')
			Spring2.queue_free()
		
		ropeSegment.pointA = pointA
		ropeSegment.pointB = pointB



func removeRope():
	var RopeUI :Label= $"../UI/Label"
	RopeUI.text = str('ROPE DETTACHED')
	for child in get_children():
		child.queue_free()
