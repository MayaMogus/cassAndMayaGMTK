@tool
extends Node2D

@export_range(25, 750, 25) var boostPadForce : float = 25


@export_range(32, 912, 32) var collider_width: float = 32
@export_range(32, 512, 32) var collider_height: float = 32

func _ready():
	_update_collider()

func _enter_tree():
	if Engine.is_editor_hint():
		set_process(true)

func _process(_delta):
	# Optionally live update in editor
	
	if Engine.is_editor_hint():
	
		_update_collider()

func _update_collider():
	var target_size = Vector2(collider_width, collider_height)
	var base_size =  Vector2(50, 50)
	scale = target_size / base_size
	$Area2D/CollisionShape2D/Sprite2D.material.set_shader_parameter("shine_speed", lerp(1, 45, boostPadForce/750))
	
	
var bodies = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func  _physics_process(delta: float) -> void:
	for rigidBody:RigidBody2D in bodies:
		var distanceRatio = 1 #- (global_position.distance_to(rigidBody.global_position) / $Area2D/CollisionShape2D.scale.x * 8)
		var direction = Vector2.RIGHT.rotated(rotation)
		rigidBody.boostPadSpeed = -boostPadForce * direction
		print(-boostPadForce * direction)
		
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		bodies.append(body)
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if bodies.has(body):
		bodies.erase(body)
		body.boostPadSpeed = Vector2(1,1)
