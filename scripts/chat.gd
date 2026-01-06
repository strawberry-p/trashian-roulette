extends PanelContainer

@export var scoreLabel: Label

var total_score = 0

signal balloon_popped(text: String)

func display(text: String) -> void:
	total_score += 1
	scoreLabel.text = str(total_score)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($".", "scale", Vector2(1,1), 0.5)
	tween.tween_interval(2)
	tween.tween_property($".", "scale", Vector2(0,0), 0.5)
	tween.play()

	$HBoxContainer/ChatPanel/Verb.text = ["DESTROYED", "OBLITERATED", "MURDERED"][randi_range(0, 2)]
	$HBoxContainer/ChatPanel/Filename.text = text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	balloon_popped.connect(display)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
