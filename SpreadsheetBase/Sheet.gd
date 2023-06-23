extends Tabs
class_name SpeadsheetTab


var data: Array = [] setget set_data, get_data




func set_data(new_data: Array) -> void:
	data = new_data


func get_data() -> Array:
	return data
