extends Node2D

@export var balloonObject: PackedScene
@export var points: PackedVector2Array
@export var files: PackedStringArray

func _ready() -> void:
	assert(points.size() == files.size())
		
	for i in range(points.size()):
		var balloon = balloonObject.instantiate()
		balloon.init(position + points[i], files[i])
		add_sibling.call_deferred(balloon)


func _process(delta: float) -> void:
	pass
