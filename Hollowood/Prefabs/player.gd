extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotateDir = null
var targetAngle = rotation.y
var startingAngle = rotation.y
var canRotate = true
var rotateTimer 

func _ready():
	rotateTimer = $rotatetimer

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_just_pressed("RotateLeft") and canRotate == true:
			startingAngle = rotation.y 
			targetAngle = (rotation.y + deg_to_rad(90))
			canRotate = false
			rotateTimer.start(0.3)
		if Input.is_action_just_pressed("RotateRight") and canRotate == true:
			startingAngle = rotation.y
			targetAngle = (rotation.y - deg_to_rad(90))
			canRotate = false
			rotateTimer.start(0.3)
		

		
	print(targetAngle)
	move_and_slide()
	
	if targetAngle != rotation.y:
		rotation.y = lerp_angle(rotation.y,targetAngle,deg_to_rad(10))
	

		


func _on_rotatetimer_timeout():
	canRotate = true
