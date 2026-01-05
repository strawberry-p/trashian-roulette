extends RigidBody2D

@export var speed = 200

var move = false;
var dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(move):
		move_and_collide(dir * speed * delta)
		if scale[0] > 0.2:
			scale[0] -= 0.03
	look_at(get_global_mouse_position());
	if(!move && Input.is_action_just_pressed("Click")):
		dir = position.direction_to(get_global_mouse_position()).normalized()
		move = true
