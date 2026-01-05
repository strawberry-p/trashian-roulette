extends RigidBody2D

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var collision = move_and_collide(Vector2(0, -speed * delta))
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("is_in_group") && collider.is_in_group("balloon"):
			collider.start_explode()
			hide()
	if scale[1] > 0.2:
		scale[1] -= 0.03;
