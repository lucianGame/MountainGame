extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck #assigns the new variable to the neck object in the scene
@onready var camera := $Neck/Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #the cursor will dissapear on clicking
	elif event.is_action_pressed("ui_cancel"): # ui_cancel is set to the esc button
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #the cursor becomes visible if you press esc
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: #when the cursor is not visible
		if event is InputEventMouseMotion: #if the mouse is moving
			neck.rotate_y(-event.relative.x * 0.01)		#rotate the camera relative to the mouse
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("Run"):
		SPEED = 8
	if Input.is_action_just_released("Run"):
		SPEED = 5
	
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() #the transform is linked to the neck
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
