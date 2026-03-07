extends CharacterBody2D


const SPEED = 100.0
const FRICTION = 10
@onready var arm = $SpriteArm


func _physics_process(delta: float) -> void:
	#var arm_dir = get_global_mouse_position() - arm.global_position
	arm.look_at(get_global_mouse_position())
	arm.rotation += deg_to_rad(-90)
	#arm.flip_h = arm_dir.x > 0
	#
	#if arm.flip_h:
		#arm.position.y = -18
	#else:
		#arm.position.y = -16
	
	var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if direction:
		velocity = direction * SPEED
		print(velocity)
	else:
		#velocity = move_toward(velocity, 0, SPEED)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

	move_and_slide()
