extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)
	pass # Replace with function body.


func _get_input():
	if is_on_floor():
		##if player is on the floor
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed,0)
			##if key to move left is pressed, move to the left by subtracting movement speed

		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed,0)
			##if key to move right is pressed, move to the right 
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height)
			##if jump key is pressed, increase velocity by jump vector to jump
	if not is_on_floor():
		##if player is not on the floor/in the air
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)
			##if move left key pressed, move based on movement speed and horizontal air effects
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)
			##if move right key pressed, move right based on speed and air coefficient
func _limit_speed():
	if velocity.x > speed_limit:
		velocity = Vector2(speed_limit, velocity.y)
		##if the character is faster than speed limit in x direction, set velocity to speed limit(leave y alone)
	if velocity.x < -speed_limit:
		velocity = Vector2(-speed_limit, velocity.y)
		##if the velocity is less than the speed limit in the opposite direction, update velocity to speed limit (leave y alone)
func _apply_friction():
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		## if on the floor and not moving with keys
		velocity -= Vector2(velocity.x * friction, 0)
		##slow character down
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

func _apply_gravity():
	if not is_on_floor():
		velocity += gravity
		##if the character is not on the floor/in the air, apply gravity to its velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide()
	pass
