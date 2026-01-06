extends RigidBody2D

var active = true
var filepath: String

func _ready() -> void:
	pass

func init(pos: Vector2, label: String):
	position = pos
	filepath = label
	$Label.text = label.split("/")[len(label.split("/"))-1]

func _physics_process(delta: float) -> void:
	if !active:
		return
	for coll in get_colliding_bodies():
		if coll && coll.is_in_group("knife"):
			$AudioStreamPlayer2D.pitch_scale = randf() * 2
			$AudioStreamPlayer2D.playing = true
			$AnimatedSprite2D.play("pop")
			active = false
			DirAccess.remove_absolute(filepath)
