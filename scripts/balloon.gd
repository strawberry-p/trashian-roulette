extends RigidBody2D

var active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func init(pos: Vector2, label: String):
	position = pos
	$Label.text = label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active:
		return
	for coll in get_colliding_bodies():
		if coll && coll.is_in_group("knife"):
			start_explode()
			coll.hide()
			active = false

func start_explode():
	$AnimatedSprite2D.play("pop")
	#hide()
	#$AnimationPlayer.play("explode")
