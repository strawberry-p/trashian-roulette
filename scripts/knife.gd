extends RigidBody2D

@export var speed = 1000
@export var curve = 72

var move = false;
var dir: Vector2
var initialPos: Vector2
var pixels = 0.0



func _ready() -> void:
	initialPos = position

func respawn() -> void:
	scale.x = 1.0
	position = initialPos
	move = false
	show()

func modulo(a, b):
	if(a < b):
		return a
	if(a > b):
		while(a > b):
			a -= b
		return a

func _physics_process(delta: float) -> void:
	if !$VisibleOnScreenNotifier2D.is_on_screen():
		respawn()
	if move:
		move_and_collide(dir * speed * delta)
		position.x += pixels
		if(modulo(abs(rotation_degrees), 360) < 90):
			pixels += -curve * delta
		else:
			pixels += curve * delta
		if scale.x > 0.2:
			scale.x -= 0.03
	else:
		look_at(get_global_mouse_position());
		if Input.is_action_just_pressed("Click"):
			pixels = 0.0
			dir = position.direction_to(get_global_mouse_position()).normalized()
			move = true
