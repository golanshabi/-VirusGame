extends CharacterBody2D


const SPEED = 130.0
const JUMP_SINGLE_VELOCITY = -250.0
const GRAVITY_REDUCTION_RATIO = 0.70
const FLOATINESS = 0.95
# State variables
var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		var gravity = get_gravity() * delta * FLOATINESS
		if velocity.y < 0 and Input.is_action_pressed("ui_accept"):
			gravity = gravity * GRAVITY_REDUCTION_RATIO
		velocity += gravity

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_SINGLE_VELOCITY
		jump_count += 1

	if jump_count > 1 and is_on_floor():
		jump_count = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
