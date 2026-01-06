extends Node2D

@export var balloonObject: PackedScene
@export var knifeObject: PackedScene
@export var points: PackedVector2Array
@export var knifeSpawnPoint: Vector2

var canShoot = true
var power = 0.0;
var raw_power = 0.0;
var power_dir = false

func calculate_score(dir: String, filename: String) -> int:
	if dir.contains("tmp") || dir.contains("Downloads") || dir.contains("Trash") || dir.contains("cache"):
		return -1
	var spl = filename.split(".")
	if spl.size() < 2 || spl[spl.size() - 1] == "":
		return 0
	match spl[spl.size() - 1]:
		"docx", "doc", "md", "pub", "pdf", "flac", "psd", "ai", "ani", "AppImage", "desktop", "ppt", "pttx", "xls", "xlsx", "kra", "bat", "ps1", "py", "c", "cpp", "h", "hpp", "go", "rs", "hs", "lhs":
			return 2
		"ebup", "mp3", "wav", "txt", "iso", "ttf", "mp4", "mkv", "jpg", "jpeg", "png", "zip", "gif", "webm":
			return 1
		"log", "gz", "tmp", "temp", "old", "dmp", "gid", "fts", "bak", "out":
			return -1
		_:
			return 0

func filter_perms(dirPath: String) -> Dictionary:
	var filtered = {}
	for i in DirAccess.get_files_at(dirPath):
		var fp = dirPath + "/" + i
		var p = FileAccess.get_unix_permissions(fp)
		if OS.get_name() == "Windows" || p ^ FileAccess.UNIX_WRITE_OWNER || p ^ FileAccess.UNIX_WRITE_GROUP || p ^ FileAccess.UNIX_WRITE_OTHER:
			filtered[fp] = calculate_score(dirPath, fp)
	return filtered

func gather_files(path: String) -> Array:
	var files = DirAccess.get_directories_at(path)
	var gathered = {}
	gathered.merge(filter_perms(path))
	for dir in DirAccess.get_directories_at(path):
		gathered.merge(filter_perms(path + "/" + dir))
		for dir_2 in DirAccess.get_directories_at(path + "/" + dir):
			gathered.merge(filter_perms(path + "/" + dir + "/" + dir_2))
	var keys = gathered.keys()
	keys.sort_custom(func(a, b): return gathered[a] < gathered[b])
	var sorted_gathered = {}
	for key in keys:
		sorted_gathered[key] = gathered[key]
	
	var sorted_keys = sorted_gathered.keys()
	var output = []
	for ki in range(sorted_keys.size() / 2):
		output.append(sorted_keys[ki])
		output.append(sorted_keys[sorted_keys.size() - ki - 1])
		
	return output

@onready var files = gather_files(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))

func easeOutCubic(x):
	return 1 - (1 - x) * (1 - x);

func _ready() -> void:
	assert(points.size() <= files.size())
	for i in range(points.size()):
		var balloon = balloonObject.instantiate()
		balloon.init(position + points[i], files[i])
		files.erase(i)
		add_sibling.call_deferred(balloon)

func recharge() -> void:
	canShoot = true

func _process(delta: float) -> void:
	if !canShoot:
		return
	
	if Input.is_action_pressed("Click"):
		if(raw_power < 1) and not power_dir:
			raw_power += 0.05
			power = easeOutCubic(raw_power)
		elif(not power_dir):
			power_dir = true
		if(raw_power > 0) and power_dir:
			raw_power -= 0.05
			power = easeOutCubic(raw_power)
		elif(power_dir):
			power_dir = false
		if(power < 0):
			power = 0
		if(power > 1):
			power = 1
		$"../leMove/".position.y = 339 - 512.0 * power

	if Input.is_action_just_released("Click"):
		$"../leMove/".position.y = 339 - 512.0 * power
		canShoot = false
		var inst = knifeObject.instantiate()
		inst.init(global_position + knifeSpawnPoint, Vector2(get_global_mouse_position().x, 648 - 648*power), recharge)
		add_sibling(inst)
		power = 0
		$"../leMove/".position.y = 339 - 512.0 * power
		
