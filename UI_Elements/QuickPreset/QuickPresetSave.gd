extends Resource
class_name QuickPresetSave

const QUICK_PRESET_SAVE_PATH: String = "user://quick_preset_save.tres"


export var preset_info: Array = [] setget set_preset_info, get_preset_info# [{"id": x, "path": string}, ...]




func add_preset_path(new_path: String) -> void:
	print("add path to quick presets save: ", new_path)
	if !preset_info.empty():
		print("presets not emtpy")
		for preset in preset_info:
			if preset.get("path") == new_path:
				return
	var new_dict: Dictionary = {
		"id": preset_info.size(),
		"path": new_path
	}
	print("added dictionary: ", new_dict)
	var temp: Array = preset_info.duplicate()
	temp.append(new_dict)
	preset_info = temp
	set_preset_info(temp)


func set_preset_info(new_preset_info: Array) -> void:
	preset_info = new_preset_info


func remove_preset_path(path: String) -> void:
	if preset_info.has(path):
		preset_info.erase(path)


func get_preset_info() -> Array:
	return preset_info
