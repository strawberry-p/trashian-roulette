extends Node2D

@export var balloonObject: PackedScene
@export var points: PackedVector2Array
@export var files: PackedStringArray

var filesDict: Dictionary

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
		"log", "tar.gz", "tmp", "temp", "old", "dmp", "gid", "fts":
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

func gather_files(path: String) -> Dictionary:
	var files = DirAccess.get_directories_at(path)
	var gathered = {}
	gathered.merge(filter_perms(path))
	for dir in DirAccess.get_directories_at(path):
		gathered.merge(filter_perms(path + "/" + dir))
		for dir_2 in DirAccess.get_directories_at(path + "/" + dir):
			gathered.merge(filter_perms(path + "/" + dir + "/" + dir_2))
	return gathered

@onready var filess = gather_files(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))

func _ready() -> void:
	assert(points.size() == files.size())
	for i in range(points.size()):
		var balloon = balloonObject.instantiate()
		balloon.init(position + points[i], files[i])
		var inx = randi_range(0, files.size()-1)
		balloon.get_child(3).text = filess.keys()[inx].split("/")[len(filess.keys()[inx].split("/"))-1]
		filess.erase(filess.keys()[inx])
		add_sibling.call_deferred(balloon)


func _process(delta: float) -> void:
	pass
