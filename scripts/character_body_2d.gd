extends RigidBody2D
class_name Player

@export var ropeClick : AudioStream
@export var ropeSound2 : AudioStream


const SPEED := 500.0
const ACCELERATION := 10.0
const JUMP_VELOCITY := -550.0
const COYOTE_TIME_SECONDS := 0.1
const WALL_HIT_SAVE_TIME_SECONDS := 0.075
const GRAVITY := 800.0

var coyote_timer := 0.0
var grounded: bool = false
var wall_hit_save_timer := 0.0
var wall_hit_save_velocity: float
var wall_hit_save_active: bool
var hit_wall: bool

var queued_jump := false
var previous_velocity := Vector2.ZERO

@onready var ray_floor_left = $Raycasts/groundLeftDetection
@onready var ray_floor_right = $Raycasts/groundRightDetection
@onready var ray_wall_left = $Raycasts/wallLeftDetection
@onready var ray_wall_right = $Raycasts/wallRightDetection

var amount = 70
var length = 0.2
var pivotCandidate : StaticBody2D = null
var ropeAttached : bool = false
var main : Node2D

var currentPivot = null

var respawnLocation : Vector2

var collectedKeys = []
var savedKeys = []

func _ready() -> void:
	main = get_parent().get_parent()
	$PinJoint2D.softness = 1000
	respawnLocation = global_position

var move_force = 2000.0

var storedVelocity = 0

var speed : int = 0
var direction : int = 1
var maxDist = 700
var trueMaxDist = maxDist
var boostPadSpeed = Vector2(0,0)

var isUpsideDown :int=1

func _physics_process(delta: float) -> void:
	
	$Sprite2D.scale.y = lerp($Sprite2D.scale.y, 0.215, delta*10)
	
	
	# Check grounded state with rays
	var was_grounded = grounded
	grounded = ray_floor_left.is_colliding() or ray_floor_right.is_colliding()
	
	# Coyote time logic
	if grounded:
		coyote_timer = 0
	elif was_grounded:
		coyote_timer += delta
		if coyote_timer > COYOTE_TIME_SECONDS:
			coyote_timer = 0  # expires

	# Wall hit detection
	var touching_wall = ray_wall_left.is_colliding() or ray_wall_right.is_colliding()
	if touching_wall:
		if not hit_wall:
			wall_hit_save_velocity = previous_velocity.x
			hit_wall = true
		wall_hit_save_timer += delta
	elif hit_wall:
		if wall_hit_save_timer <= WALL_HIT_SAVE_TIME_SECONDS and linear_velocity.x == 0:
			linear_velocity.x = wall_hit_save_velocity
		wall_hit_save_timer = 0
		hit_wall = false

	# Gravity
	if not grounded:
		var gravity_force = GRAVITY * (1.0 if linear_velocity.y > 0 else 2.0)
		linear_velocity.y += gravity_force * delta
		 
	# Jumping
	if Input.is_action_just_pressed("up") and not grounded:
		queued_jump = true
	elif (grounded or coyote_timer > 0.0) and (
		Input.is_action_just_pressed("up") or
		(queued_jump and Input.is_action_pressed("up"))
	):
		
		linear_velocity.y = JUMP_VELOCITY
		queued_jump = false
		coyote_timer = 0
		
	if linear_velocity.x < 0:
		
		$Sprite2D.scale.x = -0.215

	elif linear_velocity.x > 0:
		$Sprite2D.scale.x = 0.215
	
	#print(boostPadSpeed)
	# Acceleration
	var distance = 0
	if currentPivot != null:
		distance = global_position.distance_to(currentPivot)
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		
		$Sprite2D.texture = load("res://assets/spriteTurn.png")
		
		

		linear_velocity.x += direction * ACCELERATION * (
			1.0 if sign(direction) == sign(linear_velocity.x) else 2.0
		)
		
		
	else:
		# Decelerate
		
		$Sprite2D.texture = load("res://assets/spriteStand.png")
		var decel = ACCELERATION / (2.0 if grounded else 4.0)
		linear_velocity.x -= sign(linear_velocity.x) * decel
		if abs(linear_velocity.x) < ACCELERATION:
			linear_velocity.x = 0

	previous_velocity = linear_velocity
	linear_velocity += Vector2(-boostPadSpeed.y, boostPadSpeed.x)
	
	linear_velocity.x = clamp(linear_velocity.x, -SPEED*8, SPEED*8)
	if currentPivot != null:
		$Label.text = str(distance, ' / ', maxDist)
		if not grounded:
			$Sprite2D.look_at(currentPivot)
			$Sprite2D.rotation -= PI / 2
			isUpsideDown = -1
		else:
			$Sprite2D.rotation = 0
			isUpsideDown = 1
		
		#print(global_position.x,' ', currentPivot.x)
		
		#global_position.y = clamp(global_position.y, currentPivot.global_position.y - maxDist, currentPivot.global_position.y + maxDist)
		if distance > maxDist:
			var directionImpulse = (currentPivot - global_position).normalized()
			var correction = directionImpulse * (distance - maxDist)
			#global_position.x = lerp(global_position.x, currentPivot.x , delta*.01)
			#global_position.y = lerp(global_position.y, currentPivot.y , delta*10)
			var force = correction * distance/10
			apply_central_impulse(force)
	else:
		$Sprite2D.rotation = 0
		isUpsideDown = 1
		
func _input(event: InputEvent) -> void:
	var ropeController : Node2D = main.get_node('ropeController')
	if Input.is_action_just_pressed("attach_rope"):
		#print(pivotCandidate)
		if not ropeAttached:
			if pivotCandidate != null:
				ropeAttached = true
				ropeController.attachRope(length, amount, pivotCandidate)
				$PinJoint2D.node_b = pivotCandidate.get_path()
				$PinJoint2D.node_a = $".".get_path()
				$Sprite2D.scale.y = .1
				currentPivot = pivotCandidate.global_position
				playSound(ropeClick)
				
		else:
			ropeAttached = false
			#print('REMOVE')
			ropeController.removeRope()
	if Input.is_action_just_pressed("ui_down"):
		reload_scene()
	
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		
		$Sprite2D.scale.y = .1
	
func _on_pivot_detector_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body is Pivot:

		var RopeUI :Label= main.get_node('UI/Label')
		#RopeUI.text = str('PIVOT IN RANGE')
		pivotCandidate = body
	elif body.name == 'Checkpoint':

		respawnLocation = body.global_position 
		savedKeys = collectedKeys.duplicate()
		print('SAVING KEYS', savedKeys, collectedKeys)
func _on_pivot_detector_body_exited(body: Node2D) -> void:
	if body is Pivot:
		pivotCandidate = null

func reload_scene():
	var current_scene = get_tree().current_scene
	var packed_scene = ResourceLoader.load(current_scene.scene_file_path)
	get_tree().change_scene_to_packed(packed_scene)


func _on_spike_detector_body_entered(body: Node2D) -> void:
	if body.name == 'Spike':
	
		die()
		
func die():
	linear_velocity = Vector2(0,0)
	
	ropeAttached = false

	
	
	var ropeController : Node2D = main.get_node('ropeController')
	ropeController.removeRope()
	
	var keyController : Node2D = main.get_node('Keys')
	var gateController : Node2D = main.get_node('Gates')
	print(savedKeys, 'savedKeys')
	for key in keyController.get_children():
		if not savedKeys.has(key.keyIndex):
			
			key.call_deferred('showKey')
		else:
			print('???')
		
	for gate in gateController.get_children():
		if not savedKeys.has(gate.gateIndex):
			gate.call_deferred('reappear')
			
	
	collectedKeys = savedKeys.duplicate()
	await get_tree().process_frame 
	set_deferred("global_position", respawnLocation)

func playSound(sound:AudioStream):
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()


func _on_music_player_finished() -> void:
	
	$MusicPlayer.play()
