extends CharacterBody2D


const SPEED = 100.0
const FRICTION = 10
var walk_tween: Tween = null
var arm_tween: Tween
var fire_rate := 0.1
var can_shoot := true
@onready var player_body = $SpriteBody
@onready var player_arm = $SpriteArm
@onready var particles_flash = $SpriteArm/ParticlesFlash
@onready var particles_shell = $SpriteArm/ParticlesShell
@onready var marker_gun = $SpriteArm/MarkerGun
@onready var bullets = $"../Bullets"
const BulletScene: PackedScene = preload("res://scenes/bullet.tscn")
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()


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
	
	walk_tween.tween_property(player_body, "rotation", deg_to_rad(5), 0.14)
	walk_tween.tween_property(player_body, "rotation", deg_to_rad(-5), 0.14)


func stop_walk_animation() -> void:
	if walk_tween:
		walk_tween.kill()
		walk_tween = null
	
	player_body.rotation = 0


func rotate_arm() -> void:
	#print(wrapf(rad_to_deg(player_arm.rotation), 0, 360))
	var arm_direction = get_global_mouse_position() - player_arm.global_position
	#print(player_arm.global_position.x)
	#print(get_global_mouse_position().x)
	player_arm.look_at(get_global_mouse_position())
	player_arm.rotation += deg_to_rad(-90)
	
	if arm_direction.x > 0:
		player_arm.scale.x = -1
	else:
		player_arm.scale.x = 1

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
		bullet.player_arm_rotation_degrees = player_arm.global_rotation_degrees
		bullet.global_position = marker_gun.global_position
		bullets.add_child(bullet)
		
		#print("Bang!")
		particles_flash.emitting = true
		particles_shell.emitting = true
		
		#print(player_arm.global_rotation_degrees)
		
		if arm_tween:
			arm_tween.kill()
		
		var player_arm_original_position = Vector2(15, -16)
		arm_tween = create_tween().set_parallel(false)
		arm_tween.tween_property(player_arm, "position", player_arm_original_position + Vector2(-4, 0), 0.05)
		arm_tween.tween_property(player_arm, "position", player_arm_original_position, 0.1)
		
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true
	
	if Input.is_action_just_released("shoot"):
		particles_flash.emitting = false
		particles_shell.emitting = false
