extends Node2D

@export var balloonObject: PackedScene
@export var points: PackedVector2Array
@export var files: PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(points.size() == files.size())
		
	for i in range(points.size()):
		var balloon = balloonObject.instantiate()
		balloon.init(position + points[i], files[i])
		add_sibling.call_deferred(balloon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
