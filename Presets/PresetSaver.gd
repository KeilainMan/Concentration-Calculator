extends Resource
class_name PresetSaver

#export var all_tab_resources: Array = [] setget set_all_tab_resources, get_all_tab_resources

export var all_tab_properties: Array = [] setget set_all_tab_properties, get_all_tab_properties

#func set_all_tab_resources(new_resources: Array) -> void:
#	all_tab_resources.clear()
#	print(new_resources)
#	all_tab_resources.append_array(new_resources)
#	print("everything appended")
#
#
#func get_all_tab_resources() -> Array:
#	return all_tab_resources

func set_all_tab_properties(new_properties: Array) -> void:
	all_tab_properties.clear()
	all_tab_properties.append_array(new_properties)


func get_all_tab_properties() -> Array:
	return all_tab_properties
