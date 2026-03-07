extends CharacterBody2D


const SPEED = 100.0
const FRICTION = 10
var walk_tween: Tween = null
var fire_rate := 0.1
var can_shoot := true
@onready var player_body = $SpriteBody
@onready var player_arm = $SpriteArm
@onready var particles_flash = $SpriteArm/ParticlesFlash
@onready var particles_shell = $SpriteArm/ParticlesShell
@onready var marker_gun = $SpriteArm/MarkerGun
@onready var bullets = $"../Bullets"
const BulletScene: PackedScene = preload("res://scenes/bullet.tscn")


func _physics_process(_delta: float) -> void:
	walk()
	rotate_arm()
	shoot()


func walk() -> void:
	var direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if direction:
		velocity = direction * SPEED
		if walk_tween == null:
			start_walk_animation()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
		stop_walk_animation()
	
	move_and_slide()


func start_walk_animation() -> void:
	if walk_tween:
		walk_tween.kill()
		
	walk_tween = create_tween()
	walk_tween.set_loops()
	
	walk_tween.tween_property(player_body, "rotation", deg_to_rad(5), 0.2)
	walk_tween.tween_property(player_body, "rotation", deg_to_rad(-5), 0.2)


func stop_walk_animation() -> void:
	if walk_tween:
		walk_tween.kill()
		walk_tween = null
	
	player_body.rotation = 0


func rotate_arm() -> void:
	#var arm_dir = get_global_mouse_position() - player_arm.global_position
	player_arm.look_at(get_global_mouse_position())
	player_arm.rotation += deg_to_rad(-90)
	#player_arm.flip_h = arm_dir.x > 0
	
	#if player_arm.flip_h:
		#player_arm.position.y = -18
	#else:
		#player_arm.position.y = -16


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#print(position.angle_to_point(get_global_mouse_position()))
		#print(position.direction_to(get_global_mouse_position()))
		#print(get_global_mouse_position())
		#
		#if event.pressed:
			#shoot()
			#particles_flash.emitting = true
			#particles_shell.emitting = true
		#else:
			#particles_flash.emitting = false
			#particles_shell.emitting = false


func shoot() -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		
		var bullet = BulletScene.instantiate()
		bullet.direction = marker_gun.global_position.direction_to(get_global_mouse_position())
		bullet.global_position = marker_gun.global_position
		bullets.add_child(bullet)
		
		#print("Bang!")
		particles_flash.emitting = true
		particles_shell.emitting = true
		
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true
	
	if Input.is_action_just_released("shoot"):
		particles_flash.emitting = false
		particles_shell.emitting = false
		
	
