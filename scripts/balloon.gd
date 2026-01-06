extends RigidBody2D

var active = true
var filepath: String
var i = 0

func _ready() -> void:
	pass

func init(pos: Vector2, label: String, ii):
	position = pos
	filepath = label
	$Label.text = label.split("/")[len(label.split("/"))-1]
	i = ii

func hidee():
	hide()

func _physics_process(delta: float) -> void:
	if !active:
		return
	for coll in get_colliding_bodies():
		if coll && coll.is_in_group("knife"):
			coll.collided()
			$AudioStreamPlayer2D.pitch_scale = randf() * 0.7 + 0.7
			$AudioStreamPlayer2D.playing = true
			$AnimatedSprite2D.play("pop")
			active = false
			$"../Spawner".positions.append(i)
			$"../Spawner".last_knife = $"../Spawner".knife
			$"../Spawner".knife = coll
			$Label.hide()
			$AnimatedSprite2D.animation_finished.connect(hidee)
			#DirAccess.remove_absolute(filepath)
