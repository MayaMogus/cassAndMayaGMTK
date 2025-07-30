extends RigidBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var amount = 50
var length = 0.2
var pivotCandidate : StaticBody2D = null
var ropeAttached : bool = false
var main : Node2D

func _ready() -> void:
	main = get_parent().get_parent()
	
var move_force = 2000.0

func _physics_process(delta):
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	
	if input_dir != Vector2.ZERO:
		apply_central_force(input_dir.normalized() * move_force)

func _input(event: InputEvent) -> void:
	var ropeController : Node2D = main.get_node('ropeController')
	if Input.is_action_just_pressed("space"):
		if not ropeAttached:
			if pivotCandidate != null:
				ropeAttached = true
				ropeController.attachRope(length, amount, pivotCandidate)
		else:
			ropeAttached = false
			print('REMOVE')
			ropeController.removeRope()
			
			
func _on_pivot_detector_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == 'Pivot':
		print('RA')
		var RopeUI :Label= main.get_node('UI/Label')
		RopeUI.text = str('PIVOT IN RANGE')
		pivotCandidate = body


func _on_pivot_detector_body_exited(body: Node2D) -> void:
	if body.name == 'Pivot':
		pivotCandidate = null
