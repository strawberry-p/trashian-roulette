extends RigidBody2D

var active = true

func _ready() -> void:
	pass

func init(pos: Vector2, label: String):
	position = pos
	$Label.text = label

func _physics_process(delta: float) -> void:
	if !active:
		return
	for coll in get_colliding_bodies():
		if coll && coll.is_in_group("knife"):
			$AnimatedSprite2D.play("pop")
			active = false
