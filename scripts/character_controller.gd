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
		velocity.x -= sign(velocity.x) * ACCELERATION / (2.0 if is_on_floor() else 4.0)
		# handle offsets less than the acceleration amount
		if abs(velocity.x) < ACCELERATION: velocity.x = 0

	# rope attachment
	if Input.is_action_just_pressed("attach_rope"):
		if not attached:
			# attach rope
			attached = true
			CreateRope(position, attachment_point.position)
		else:
			# detach rope
			attached = false
			# TODO: put shit here

	previous_velocity = velocity
	move_and_slide()

func CreateRope(start: Vector2, end: Vector2):
	pass

# TODO: what happens if there's multiple points in range?
func _on_AttachmentDetector_body_entered(body: Node2D) -> void:
	if body.name == "AttachmentPoint":
		attachment_point = body
	
func _on_AttachmentDetector_body_exited(body: Node2D) -> void:
	if body.name == "AttachmentPoint":
		attachment_point = null

func clamp(value, minimum, maximum):
	return min(max(value, minimum), maximum)
