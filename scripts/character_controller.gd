extends RigidBody2D

# used for raycasts
var space_state: PhysicsDirectSpaceState2D:
	get: return get_world_2d().direct_space_state

const SPEED := 850.0
const ACCELERATION := 35.0
const MAX_GROUND_SLOPE := 0.5
var is_on_floor := true
var is_on_wall := false

const JUMP_VELOCITY := -750.0
const MAX_JUMP_TIME_SECONDS := 0.2
var jumping := false
var jumping_timer := 0.0
var queued_jump := false

const COYOTE_TIME_SECONDS := 0.1
var grounded: bool
var coyote_timer := 0.0

const WALL_HIT_SAVE_TIME_SECONDS := 0.1
var wall_hit_save_timer := 0.0
var wall_hit_save_velocity: float
var wall_hit_save_active: bool
var hit_wall: bool

var previous_velocity := Vector2.ZERO
var center_position: Vector2:
	get: return global_position - Vector2(0, $"CollisionShape2D".shape.size.y / 2)

const SPRING_DAMPING := 10.0
const SPRING_STIFFNESS := 150.0
const ROPE_BACKTRACK_TOLERANCE := 2.0
var attached := false
var attachment_point: Node2D
var attachment_point_candidates: Dictionary[Node2D, Vector2]
@onready var rope_visual := Line2D.new()
var rope_points: PackedVector2Array = []
var rope_remaining_length: float

var collected_keys = []
var saved_keys = []

var upside_down := false
var timer:float

var lockedControls : bool = false

@onready var respawn_position := global_position
@onready var reset_position := global_position
@onready var base_node := $".."

@onready var stand_texture := preload("res://assets/spriteStand.png")
@onready var turn_texture := preload("res://assets/spriteTurn.png")

@export var ropeAttachSound : AudioStream
@export var splatSound : AudioStream
var boost_pad_speed := Vector2.ZERO

var paused := false

var saved_velocity_paused : Vector2


func _ready() -> void:
	var rope_image := Image.load_from_file("res://assets/rope.png")
	rope_image.rotate_90(CLOCKWISE)
	rope_image.resize(rope_image.get_width() * 2, rope_image.get_height())
	var rope_texture := ImageTexture.create_from_image(rope_image)
	rope_visual.joint_mode = Line2D.LINE_JOINT_ROUND
	rope_visual.begin_cap_mode = Line2D.LINE_CAP_ROUND
	rope_visual.end_cap_mode = Line2D.LINE_CAP_ROUND
	rope_visual.texture = rope_texture
	rope_visual.texture_mode = Line2D.LINE_TEXTURE_TILE
	rope_visual.width = 15
	base_node.add_child.call_deferred(rope_visual)
	
	$Radius.global_position = center_position
	timer = Settings.timer
	$MusicPlayer.play()
	$MusicPlayer.seek(MusicController.musicTimer - 0.0166)

func _physics_process(delta: float) -> void:
	
	# pausing
	if Input.is_action_just_pressed('pause'):
		if not paused:
			pause()
	if paused:
		saved_velocity_paused = linear_velocity
		return
	

	
	# TODO: this sux major ass
	# TODO: set false at top and replace elif with if
	# check if we're on the floor based on raycasts and the slope of the ground
	if $Raycasts/FloorLeft.is_colliding():
		# normal.aspect is slope
		if abs($Raycasts/FloorLeft.get_collision_normal().aspect()) <= MAX_GROUND_SLOPE:
			is_on_floor = true
		else: is_on_floor = false # slope too steep
	elif $Raycasts/FloorRight.is_colliding():
		if abs($Raycasts/FloorRight.get_collision_normal().aspect()) <= MAX_GROUND_SLOPE:
			is_on_floor = true
		else: is_on_floor = false # slope too steep
	else: is_on_floor = false # no rays hit
	
	# check if we're on a wall based on raycasts and the slope of the ground
	if $Raycasts/WallLeftBottom.is_colliding():
		if abs($Raycasts/WallLeftBottom.get_collision_normal().aspect()) >= MAX_GROUND_SLOPE:
			is_on_wall = true
		else: is_on_wall = false # slope not steep enough
	elif $Raycasts/WallLeftMiddle.is_colliding():
		if abs($Raycasts/WallLeftMiddle.get_collision_normal().aspect()) >= MAX_GROUND_SLOPE:
			is_on_wall = true
		else: is_on_wall = false # slope not steep enough
	elif $Raycasts/WallLeftTop.is_colliding():
		if abs($Raycasts/WallLeftTop.get_collision_normal().aspect()) >= MAX_GROUND_SLOPE:
			is_on_wall = true
		else: is_on_wall = false # slope not steep enough
	elif $Raycasts/WallRightBottom.is_colliding():
		if abs($Raycasts/WallRightBottom.get_collision_normal().aspect()) >= MAX_GROUND_SLOPE:
			is_on_wall = true
		else: is_on_wall = false # slope not steep enough
	elif $Raycasts/WallRightMiddle.is_colliding():
		if abs($Raycasts/WallRightMiddle.get_collision_normal().aspect()) >= MAX_GROUND_SLOPE:
			is_on_wall = true
		else: is_on_wall = false # slope not steep enough
	elif $Raycasts/WallRightTop.is_colliding():
		if abs($Raycasts/WallRightTop.get_collision_normal().aspect()) >= MAX_GROUND_SLOPE:
			is_on_wall = true
		else: is_on_wall = false # slope not steep enough
	else: is_on_wall = false # no rays hit
	
	# coyote time
	if is_on_floor:
		grounded = true
	elif not is_on_floor and grounded: # if coyote time is active
		coyote_timer += delta
		if coyote_timer > COYOTE_TIME_SECONDS:
			grounded = false
			coyote_timer = 0
	
	# preserve velocity when clipping a corner
	if is_on_wall:
		if not hit_wall: # only when initially hitting the wall
			wall_hit_save_velocity = previous_velocity.x
			hit_wall = true
		wall_hit_save_timer += delta
	
	if not is_on_wall and hit_wall: # if it just stopped hitting the wall
		if wall_hit_save_timer <= WALL_HIT_SAVE_TIME_SECONDS and linear_velocity.x == 0:
			AddVelocity(wall_hit_save_velocity * (
				# give more speed back if the hit was shorter
				1 - wall_hit_save_timer / WALL_HIT_SAVE_TIME_SECONDS
				), 0)
		wall_hit_save_timer = 0
		hit_wall = false
	
	# gravity
	if linear_velocity.y > 0:
		gravity_scale = 2.0 # falling
	elif not jumping:
		gravity_scale = 1.5 # normal
	else:
		gravity_scale = 1 # jumping (holding jump)
	
	if not lockedControls:
		# jumping
		if jumping:
			if Input.is_action_pressed("jump") and jumping_timer < MAX_JUMP_TIME_SECONDS:
				jumping_timer += delta
			else:
				jumping = false
				jumping_timer = 0
		
		if Input.is_action_just_pressed("jump") and not grounded:
			queued_jump = true
		elif grounded and (
			Input.is_action_just_pressed("jump") or 
			queued_jump and Input.is_action_pressed("jump")
		):
			SetVelocity(linear_velocity.x, JUMP_VELOCITY) # jump
			jumping = true
			queued_jump = false
			grounded = false
			coyote_timer = 0
		
		# acceleration
		var horizontal_direction := Input.get_axis("move_left", "move_right")
		var vertical_direction := Input.get_axis("move_up", "move_down")
		if horizontal_direction:
			$Sprite2D.scale.x = 0.265 * sign(horizontal_direction) * (-1.0 if upside_down else 1.0)
			$Sprite2D.texture = (
				turn_texture if absf(
					fmod(
						$Sprite2D.rotation_degrees + 90,
						180
						)
					) > 15
				else stand_texture
			)
			
			if sign(horizontal_direction) != sign(linear_velocity.x):
				# slow down faster if trying to move in opposite direction
				# but only if we're under our max speed or grounded
				AddVelocity(horizontal_direction * ACCELERATION * (
					2.0 if abs(linear_velocity.x) < SPEED else 1.0
					) / (1.0 if is_on_floor else 2.0), 0) # less control when in air
			elif abs(linear_velocity.x) < SPEED * abs(horizontal_direction):
				# multiply by abs(horizontal_direction) to account for joystick controls
				
				# give normal forward accel when under our max speed
				AddVelocity(horizontal_direction * ACCELERATION / (
					# less control when in air
					1.0 if is_on_floor else 2.0
					), 0)
		elif linear_velocity.x != 0:
			# deccelerate faster on the ground
			AddVelocity(-sign(linear_velocity.x) * ACCELERATION / (2.0 if is_on_floor else 32.0), 0)
			# handle offsets less than the acceleration amount
			if abs(linear_velocity.x) < ACCELERATION and is_on_floor:
				SetVelocity(0, linear_velocity.y)
		
			$Sprite2D.texture = stand_texture
		
		if vertical_direction and attached and not is_on_floor:
			apply_central_force(Vector2(0, vertical_direction * ACCELERATION * 25))
		
	# rope attachment
	if Input.is_action_just_pressed("attach_rope"):
		if not (attached or attachment_point_candidates.is_empty()):
			# attach rope
			CreateRope(500)
			playSound(ropeAttachSound, null)
		elif attached:
			# detach rope
			DestroyRope()
			
	if Input.is_action_just_pressed("reset"):
		ResetLevel(false)
	
	
	if attached:
		# rope wrapping
		# check if the rope needs to wrap
		var query = PhysicsRayQueryParameters2D.create(
			center_position,
			rope_points[-1],
			1
			)
		var result = space_state.intersect_ray(query)
		if not result.is_empty(): # TODO: nudge this until its only barely colliding
			var rope_segment_length = result.position.distance_to(rope_points[-1])
			
			rope_remaining_length -= rope_segment_length
			rope_points.append(result.position)
		
		# check if the rope is snagged
		if rope_points.size() > 1:
			query = PhysicsRayQueryParameters2D.create(
				center_position,
				rope_points[-2],
				1
				)
			result = space_state.intersect_ray(query)
			if result.is_empty():
				rope_remaining_length += rope_points[-1].distance_to(rope_points[-2])
				rope_points.remove_at(rope_points.size() - 1)
			elif result.position.distance_to(rope_points[-2]) < ROPE_BACKTRACK_TOLERANCE:
				# TODO: try replacing with min dist between x and y?
				rope_remaining_length += rope_points[-1].distance_to(rope_points[-2])
				rope_points.remove_at(rope_points.size() - 1)
		
		# pull the player back if the rope is at full length
		if rope_remaining_length - center_position.distance_to(rope_points[-1]) < 0:
			var stretched_distance = center_position.distance_to(rope_points[-1]) \
				- rope_remaining_length
			var stretched_vector = (rope_points[-1] - center_position).normalized()
			var force = SPRING_STIFFNESS * stretched_distance \
				- SPRING_DAMPING * linear_velocity.dot(stretched_vector)
			apply_central_force(force * stretched_vector)
	
	previous_velocity = linear_velocity
	
	
	


func _process(delta: float) -> void:
	
	# attachment point range visualizer
	if not paused: 
		$Radius.rotation += 0.25 * delta 
		timer += delta 
		
	MusicController.musicTimer += delta
	
	$MusicPlayer.volume_linear = Settings.MusicLevel * 0.40 #volume is by defualy 40%
	$Timer.visible = Settings.displayTimer
	var intTimer = int(timer)
	var minutes = floor(intTimer / 60) 
	
	var seconds = intTimer - minutes * 60
	if seconds < 10:
		seconds = str('0',seconds)
	
	$Timer.text = str(minutes, ':', seconds)
	
	
	var color = $Radius.material.get_shader_parameter("dot_color")
	if not attachment_point_candidates.is_empty():
		
		$Radius.material.set_shader_parameter("dot_color", lerp(color, Color(0.3, .75, 0.3), delta*30))
	else:
		$Radius.material.set_shader_parameter("dot_color", lerp(color, Color(1,1,1), delta*30))
	
	$Sprite2D.scale.y = lerp($Sprite2D.scale.y, 0.215, delta*10) # return sprite to normal size
	if attached:
		# rope visual
		var points = rope_points.duplicate()
		points.append(center_position)
		rope_visual.points = points
		
		# face away from rope pivot
		if not grounded:
			$Sprite2D.look_at(rope_points[-1])
			$Sprite2D.rotation -= PI / 2
		else:
			$Sprite2D.rotation = 0
		
		if absf(fmod($"Sprite2D".rotation_degrees, 360)) > 90 \
			and absf(fmod($"Sprite2D".rotation_degrees, 360)) < 270:
			upside_down = true
		else:
			upside_down = false
	else:
		$Sprite2D.rotation = 0
		upside_down = false



func CreateRope(length: float):
	attached = true
	rope_remaining_length = length
	
	# find the closest attachment point candidate
	var closest_distance: float = INF
	var closest_candidate: Node2D
	
	for candidate in attachment_point_candidates:
		var candidate_position = attachment_point_candidates[candidate]
		var distance = global_position.distance_to(candidate_position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_candidate = candidate
	
	attachment_point = closest_candidate
	
	rope_points.append(attachment_point.global_position)

func DestroyRope(reset := false):
	attached = false
	rope_points.clear()
	rope_visual.clear_points()

func SetVelocity(x: float, y: float):
	apply_central_impulse((Vector2(x, y) - linear_velocity) * mass)

func AddVelocity(x: float, y: float):
	apply_central_impulse(Vector2(x, y) * mass)

func _on_attachment_detector_body_entered(body: Node2D) -> void:
	if body is Pivot:
		attachment_point_candidates[body] = body.global_position

func _on_attachment_detector_body_exited(body: Node2D) -> void:
	if body is Pivot:
		attachment_point_candidates.erase(body)

func _on_spike_detector_body_entered(body: Node2D) -> void: # TODO: rename this
	if body.get_meta("is_spike", false):
		call_deferred("ResetLevel", false)
	elif body.get_meta("is_checkpoint", false):
		respawn_position = body.global_position 
		saved_keys = collected_keys.duplicate()
		body.get_parent().shake(false if global_position < body.global_position else true)
func ResetLevel(full_reset: bool, died := true):
	DestroyRope()
	
	paused = true
	freeze = true
	$Radius.visible = false
	$Sprite2D.visible = false
	if died:
		playSound(splatSound, 1)
	await get_tree().create_timer(.5).timeout
	$Radius.visible = true
	$Sprite2D.visible = true 
	paused = false
	freeze = false
	if full_reset:
		global_position = reset_position
		respawn_position = reset_position
	else:
		global_position = respawn_position
	linear_velocity = Vector2.ZERO
	
	var key_controller : Node2D = base_node.get_node('Keys')
	var gate_controller : Node2D = base_node.get_node('Gates')
	
	if full_reset:
		collected_keys.clear()
		saved_keys.clear()
		for key in key_controller.get_children():
			key.showKey()
		for gate in gate_controller.get_children():
			gate.reappear()
	else:
		for key in key_controller.get_children():
			# show all the keys that weren't saved
			if not saved_keys.has(key.keyIndex):
				key.showKey()
		
		collected_keys = saved_keys.duplicate()
		
		for gate in gate_controller.get_children():
			# show all gates we haven't collected keys for
			if not saved_keys.has(gate.gateIndex):
				gate.reappear()

func playSound(sound:AudioStream, variance):
	$AudioStreamPlayer.volume_linear = Settings.SoundFXLevel
	if variance != null:
		var pitch_variance = randf_range(0.75, variance)
		print(pitch_variance)
		$AudioStreamPlayer.pitch_scale = pitch_variance
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()

func _on_music_player_finished() -> void:
	MusicController.musicTimer = 0
	$MusicPlayer.play()
	
func pause():
	paused = true
	freeze = true
	saved_velocity_paused = linear_velocity
	$"Pause Menu".visible = true
	
func unPause():
	freeze = false
	paused = false
	linear_velocity = saved_velocity_paused
	
	$"Pause Menu".visible = false
