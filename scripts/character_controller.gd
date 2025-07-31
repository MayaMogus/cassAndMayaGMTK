extends CharacterBody2D

const SPEED := 300.0
const ACCELERATION := 30.0
const JUMP_VELOCITY := -550.0
const COYOTE_TIME_SECONDS := 0.1
const WALL_HIT_SAVE_TIME_SECONDS := 0.075

var grounded: bool
var coyote_timer := 0.0

var wall_hit_save_timer := 0.0
var wall_hit_save_velocity: float
var wall_hit_save_active: bool
var hit_wall: bool

var queued_jump := false

var previous_velocity := Vector2.ZERO

var attached := false
var attachment_point: Node2D
var rope_visual := Line2D.new()
var rope_segments: Array[RigidBody2D] = []

func _ready() -> void:
	rope_visual.joint_mode = Line2D.LINE_JOINT_ROUND
	rope_visual.begin_cap_mode = Line2D.LINE_CAP_ROUND
	rope_visual.end_cap_mode = Line2D.LINE_CAP_ROUND
	base_node.add_child.call_deferred(rope_visual)
	
	$"../AttachmentPoint".mass = INF

func _physics_process(delta: float) -> void:
	# coyote time
	if is_on_floor():
		grounded = true
	elif not is_on_floor() and grounded:
		coyote_timer += delta
		if coyote_timer > COYOTE_TIME_SECONDS:
			grounded = false
			coyote_timer = 0
	
	# preserve velocity when clipping a corner
	if is_on_wall():
		if not hit_wall: # only when initially hitting the wall
			wall_hit_save_velocity = previous_velocity.x
			hit_wall = true
		wall_hit_save_timer += delta
	
	if not is_on_wall() and hit_wall: # if it just stopped hitting the wall
		if wall_hit_save_timer <= WALL_HIT_SAVE_TIME_SECONDS and velocity.x == 0:
			velocity.x = wall_hit_save_velocity
		wall_hit_save_timer = 0
		hit_wall = false
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * (1.0 if velocity.y > 0 else 2.0)
	
	# jumping
	if Input.is_action_just_pressed("move_up") and not grounded:
		queued_jump = true
	elif grounded and (
		Input.is_action_just_pressed("move_up") or 
		queued_jump and Input.is_action_pressed("move_up")
	):
		velocity.y = JUMP_VELOCITY
		queued_jump = false
		grounded = false
		coyote_timer = 0
	
	# acceleration
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x += direction * ACCELERATION * (
			# slow down faster if trying to move in opposite direction
			1.0 if sign(direction) == sign(velocity.x) else 2.0
		)
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
	elif velocity.x != 0:
		# deccelerate faster on the ground
		velocity.x -= sign(velocity.x) * ACCELERATION / (2.0 if is_on_floor() else 8.0)
		# handle offsets less than the acceleration amount
		if abs(velocity.x) < ACCELERATION: velocity.x = 0
	
	# rope attachment
	if Input.is_action_just_pressed("attach_rope") and attachment_point != null:
		if not attached:
			# attach rope
			attached = true
			CreateRope(position, attachment_point.position, 10, 50)
		else:
			# detach rope
			attached = false
			# TODO: put shit here
	
	previous_velocity = velocity
	move_and_slide()

func _process(_delta: float) -> void:
	if attached:
		var points: PackedVector2Array #= [attachment_point.position]
		for segment in rope_segments:
			points.append(segment.position)
		points.append(position)
		rope_visual.points = points

@onready var base_node := $".."
const SPRING_DAMPING := 0.5
const SPRING_STIFFNESS := 20.0
const SPRING_REST_LENGTH_FRACTION := 1.0
const ROPE_MASS := 0.5

func CreateRope(start: Vector2, end: Vector2, segments: int, length: float):
	var segment_difference = (end - start) / segments
	var segment_length = length / segments
	var segment_mass = ROPE_MASS / segments
	var current_position = start
	
	var rope_base = Node.new()
	rope_base.name = "Rope"
	base_node.add_child(rope_base)
	
	# create rope segments
	for i in range(segments - 1):
		current_position += segment_difference
		var spring = DampedSpringJoint2D.new()
		spring.name = "RopeSpring" + str(i)
		spring.length = segment_length
		spring.rest_length = 0
		spring.stiffness = SPRING_STIFFNESS
		spring.damping = SPRING_DAMPING
		rope_base.add_child(spring)
		
		if i == 0:
			spring.node_a = attachment_point.get_path()
			continue
		elif i == segments - 1:
			spring.node_b = self.get_path()
		
		# don't create the first and last node (they already exist)
		if i != 0:
			var node = RigidBody2D.new()
			node.name = "RopeSegment" + str(i)
			node.position = current_position
			node.mass = segment_mass
			node.collision_layer = 0 # don't collide with self
			node.collision_mask = 1 # collide with normal geo
			rope_base.add_child(node)
			rope_segments.append(node)
			
			spring.reparent(node)
			spring.global_position = node.global_position
			
			var collision = CollisionShape2D.new()
			var collision_shape = CircleShape2D.new()
			collision_shape.radius = 1.0
			collision.shape = collision_shape
			node.add_child(collision)
			
			# connect springs to this node
			var last_spring = get_node("/root/Main/Rope/RopeSpring" + str(i - 1))
			if last_spring == null: continue
			last_spring.global_rotation = last_spring.get_angle_to(node.global_position)
			spring.node_a = node.get_path()
			last_spring.node_b = node.get_path()

func DestroyRope():
	rope_segments = []
	$"../Rope".queue_free()
	rope_visual.points = []

# TODO: what happens if there's multiple points in range?
func _on_attachment_detector_body_entered(body: Node2D) -> void:
	if body.name == "AttachmentPoint":
		attachment_point = body
	
func _on_attachment_detector_body_exited(body: Node2D) -> void:
	if body.name == "AttachmentPoint":
		attachment_point = null

func clamp(value, minimum, maximum):
	return min(max(value, minimum), maximum)
