extends CharacterBody2D


const SPEED = 15
var walk_tween: Tween = null
var take_damage_tween: Tween
var health := 10
@onready var sprite = $Sprite2D
@onready var player = $"../../Player" #get_tree().current_scene.get_node("Player")


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	velocity = position.direction_to(player.global_position) * SPEED
	
	if walk_tween == null:
		walk_animation()
	move_and_slide()


func walk_animation() -> void:
	print("hej")
	if walk_tween:
		walk_tween.kill()
		
	walk_tween = create_tween()
	walk_tween.set_loops()
	
	walk_tween.tween_property(sprite, "rotation", deg_to_rad(5), 0.14)
	walk_tween.tween_property(sprite, "rotation", deg_to_rad(-5), 0.14)


func take_damage(amount) -> void:
	take_damage_animation()
	
	if health != 0:
		health -= amount
	else:
		queue_free()


func take_damage_animation() -> void:
	if take_damage_tween:
		take_damage_tween.kill()
	
	take_damage_tween = create_tween()
	var tween_time = 0.03
	var scale_bounce = 0.1
	
	take_damage_tween.tween_property(sprite, "modulate", Color.ORANGE_RED, tween_time)
	take_damage_tween.parallel().tween_property(sprite, "scale", Vector2(1 + scale_bounce, 1 + scale_bounce), tween_time)
	
	take_damage_tween.tween_property(sprite, "modulate", Color(1,1,1), tween_time)	
	take_damage_tween.parallel().tween_property(sprite, "scale", Vector2(1, 1), tween_time)
