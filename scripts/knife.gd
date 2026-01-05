extends RigidBody2D

@export var speed = 200

var move = false;
var dir: Vector2
var initialPos: Vector2

func _ready() -> void:
	initialPos = position

func respawn() -> void:
	scale.x = 1.0
	position = initialPos
	move = false
	show()

func _physics_process(delta: float) -> void:
	if(move):
		move_and_collide(dir * speed * delta)
		if scale.x > 0.2:
			scale.x -= 0.03
	look_at(get_global_mouse_position());
	if(!move && Input.is_action_just_pressed("Click")):
		dir = position.direction_to(get_global_mouse_position()).normalized()
		move = true
