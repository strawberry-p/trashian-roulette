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
		var collision = move_and_collide(dir * speed * delta)
		if collision:
			var collider = collision.get_collider()
			if collider.has_method("is_in_group") && collider.is_in_group("balloon"):
				collider.start_explode()
				hide()
				move = false
		if scale[1] > 0.2:
			scale[1] -= 0.03
	look_at(get_viewport().get_mouse_position()-Vector2(100, 0));
	rotation += 90;
	if(Input.is_action_just_pressed("Click")):
		dir = position.direction_to(get_global_mouse_position()).normalized()
		move = true
