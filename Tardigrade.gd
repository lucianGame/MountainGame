extends CharacterBody3D

var player = null

const speed = 2.0
const attackRange = 2.5

var test = 2

var state = IDLE

enum {
	IDLE,
	CHASING,
	ATTACKING
}

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

@onready var raycast = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin) #the enemy will move towards the player's position
	var next_nav_point = nav_agent.get_next_path_position()
	
	
	if raycast.is_colliding():
		state = CHASING
	
	
	match state:
		IDLE:
			test = 1
			#insert animation here
		CHASING:
			test = 2
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			move_and_slide()
			#insert animation
		ATTACKING:
			test = 3
			#insert animation
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < attackRange
