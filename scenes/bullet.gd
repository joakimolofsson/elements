extends Area2D


const SPEED = 200
var direction: Vector2
var player_arm_rotation_degrees: float
var damage := 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * SPEED * delta
	rotation_degrees = player_arm_rotation_degrees - 90
	pass


func _on_body_entered(body) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	#print("Hit:", body)
	queue_free()
