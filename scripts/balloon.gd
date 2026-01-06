extends RigidBody2D

var active = true
var filepath: String
var i = 0

var bln1 = preload("res://sprites/balloon/bln1.png")
var bln2 = preload("res://sprites/balloon/bln2.png")
var bln3 = preload("res://sprites/balloon/bln3.png")
var explosion = preload("res://explosion.tscn")

func _ready() -> void:
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Sprite2D, "scale", Vector2(2.9,2.9), 0.5)
	tween.play()

func init(pos: Vector2, label: String, ii):
	position = pos
	filepath = label
	$Sprite2D.texture = [bln1, bln2, bln3][randi_range(0, 2)]
	$Sprite2D.rotation_degrees = randi_range(-180, 180)
	$Label.text = label.split("/")[len(label.split("/"))-1]
	i = ii

func hidee():
	hide()

func _physics_process(delta: float) -> void:
	if !active:
		return
	for coll in get_colliding_bodies():
		if coll && coll.is_in_group("knife") && !coll.has_collided:
			print(coll)
			coll.collided()
			var cam = get_viewport().get_camera_2d()
			if cam && cam.has_method("shake"):
				cam.shake(10.0)
			get_parent().get_node("Chat").balloon_popped.emit($Label.text)
			var expl = explosion.instantiate()
			add_child(expl)
			$AudioStreamPlayer2D.pitch_scale = randf() * 0.7 + 0.8
			$AudioStreamPlayer2D.playing = true
			$AnimatedSprite2D.visible = true
			$Sprite2D.visible = false
			$AnimatedSprite2D.play("pop")
			active = false
			$"../Spawner".positions.append(i)
			$"../Spawner".last_knife = $"../Spawner".knife
			$"../Spawner".knife = coll
			$Label.hide()
			$AnimatedSprite2D.animation_finished.connect(hidee)
			#DirAccess.remove_absolute(filepath)
