extends Node2D

var hinge 
var current_hinge_pos: Vector2  
var originalPivot
	#@export var ropeScene : PackedScene
	#var RopeUI :Label= $"../UI/Label"
	
	#var prevRope : RigidBody2D
	#var distanceToPlayer = pivot.global_position.distance_to(player.global_position)
	#var toTheLeft : int = 1
	#var firstSegment = true
	#if pivot.global_position.x > player.global_position.x:
		#toTheLeft = -1
	##print(toTheLeft)
	##print(pivot.global_position.x,'pibot pos')
	#RopeUI.text = str('ROPE ATTACHED :' , amount)
	##print(pivot.name, 'pibot')
	#for i in amount:
		#var ropeSegment = ropeScene.instantiate()
		#add_child(ropeSegment)
		#
		#var Spring :PinJoint2D= ropeSegment.get_node('Spring')
		#var Spring2 :PinJoint2D= ropeSegment.get_node('Spring2')
		#var ropeBody : RigidBody2D = ropeSegment
		#
		#var pointA
		#var pointB
		#pointB = ropeBody
		#
		#Spring.softness = length
		#Spring.softness = length
		#
		## Position segment between pivot and player
		#
		#
			#
			#
		#var t = float(i) / float(amount - 1)
		#var pos = pivot.global_position.lerp(player.global_position, t)
		#ropeSegment.global_position = pos
			#
		#if firstSegment:
			#pointA = pivot
			#pointB = ropeSegment
			#Spring.node_a = pivot.get_path()
			#Spring.node_b = ropeSegment.get_path()
			#ropeSegment.pivot = pivot
			#Spring2.queue_free()
		#elif i == amount - 1:
			#pointA = prevRope
			#pointB = ropeSegment
			#Spring.node_a = prevRope.get_path()
			#Spring.node_b = ropeSegment.get_path()
			#
			#Spring2.node_a = player.get_path()
			#Spring2.node_b = ropeSegment.get_path()
		#else:
			#pointA = prevRope
			#pointB = ropeSegment
			#Spring.node_a = prevRope.get_path()
			#Spring.node_b = ropeSegment.get_path()
			#Spring2.queue_free()
			#
		#ropeSegment.pointA = pointA
		#ropeSegment.pointB = pointB
		#prevRope = ropeSegment
		#firstSegment = false
	#print(get_children())

var rope_points: Array[Vector2] = []


func attachRope(length, amount, pivot: StaticBody2D):
	hinge = pivot
	originalPivot = pivot
	current_hinge_pos = pivot.global_position
	rope_points = [current_hinge_pos]
	hinge_body = RigidBody2D.new()
	hinge_body.freeze = true
	get_parent().add_child(hinge_body)
	hinge_body.global_position = current_hinge_pos
	

var distanceList :Array=[]
var hinge_body: RigidBody2D = null

func _process(delta: float) -> void:
	
	if hinge != null:
		var player = $"../player".get_child(0)
		var space_state = get_world_2d().direct_space_state
		var joint = player.get_node("PinJoint2D")
			# Create hinge_body once
		var distance :float
			
		hinge_body.global_position = current_hinge_pos
		joint.node_b = hinge_body.get_path()
		#print(joint.node_b)
		var query = PhysicsRayQueryParameters2D.create(player.global_position, current_hinge_pos)
		var result = space_state.intersect_ray(query)
		
		#print("Raycast result: ", result)
		
		if result :
			if result.collider.name == 'groundCollision' or result.collider is Gate:
				var hit_pos = result.position
				#print(hit_pos, 'AAAAAAAAAAAAAAAAAA')
				if rope_points.is_empty() or rope_points.back() != hit_pos:
					rope_points.append(hit_pos)
					distance = current_hinge_pos.distance_to(hit_pos)
					
					distanceList.append(distance)
					current_hinge_pos = hit_pos  
					#print('minus :' , distance)
					player.maxDist -= distance
					player.currentPivot = hit_pos

		if rope_points.size() >= 2:
			var last_dir = (rope_points[-1] - rope_points[-2]).normalized()
			var current_dir = (player.global_position - rope_points[-1]).normalized()
			
			var dot = last_dir.dot(current_dir)
			
			
			if dot < 0:  # reversed direction
				
				rope_points.pop_back()
				current_hinge_pos = rope_points.back() if not rope_points.is_empty() else originalPivot.global_position
				#print('add :' , distanceList.size()-1)
				player.maxDist += distanceList.back()
				distanceList.remove_at(distanceList.back())
		var points = rope_points.duplicate()
		#print(points)
		points.append(player.global_position)

		var local_points = []
		for global_point in points:
			local_points.append(player.get_node("Line2D").to_local(global_point))

		player.get_node("Line2D").points = local_points
		
		
		#print(points)
		
		
#func removeRope():
	#var player = $"../Player"
	#var RopeUI :Label= $"../UI/Label"
	##RopeUI.text = str('ROPE DETTACHED')
	#var joint = player.get_node("PinJoint2D")
	#joint.node_b = NodePath("")
	#rope_points.clear()
	#hinge = null
	#player.get_node("Line2D").points = []
	#if hinge_body:
		#hinge_body.queue_free()
		#hinge_body = null
	#player.currentPivot = hinge
	#player.maxDist = player.trueMaxDist
