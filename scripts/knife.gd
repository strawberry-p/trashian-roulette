extends RigidBody2D

@export var speed = 1000
@export var curve = 72


var has_collided = false
var dir: Vector2
var pixels = 0.0
var onStop: Callable
var stopped = false
var moved = false

func init(pos: Vector2, towards: Vector2, doOnStop: Callable) -> void:
	position = pos
	$CollisionShape2D.disabled = true
	dir = towards
	onStop = doOnStop
	look_at(dir)
	if(modulo(abs(rotation_degrees), 360) < 90):
		pixels = -curve
	else:
		pixels = curve

func modulo(a, b):
	if(a < b):
		return a
	if(a > b):
		while(a > b):
			a -= b
		return a

func _physics_process(delta: float) -> void:
	if !$VisibleOnScreenNotifier2D.is_on_screen():
		stopped = true
		$CollisionShape2D.set_deferred("disabled", true)
		onStop.call()
	
	if global_position.distance_squared_to(dir) > 4.0:
		position = position.move_toward(dir + Vector2(pixels, 0), speed * delta)
		moved = true
	elif !stopped:
		stopped = true
		$CollisionShape2D.set_deferred("disabled", false)
		onStop.call()

	if scale.x > 0.2:
		scale.x -= 0.03
func _process(delta: float) -> void:
	if len(get_colliding_bodies()) < 1 and moved and global_position.distance_squared_to(dir) < 4.0:
			moved = false
			$AudioStreamPlayer2D.pitch_scale = randf() * 2
			$AudioStreamPlayer2D.seek(0)
			$AudioStreamPlayer2D.playing = true

func collided():
	has_collided = true
	$AudioStreamPlayer2D.playing = false
