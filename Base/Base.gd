extends Control

## debug setting
export var debug: bool = false
export var file_path: String = ""
export var preset_path: String = ""


var quick_preset_save: Resource
const QUICK_PRESET_SAVE_PATH: String = "user://quick_preset_save.tres"

onready var main_tab: PackedScene = preload("res://Preset_Tabs/Main_Tab/Main_Tab.tscn")
onready var main_tab_resource: Script = preload("res://Preset_Tabs/Main_Tab/Main_Tab_Resource.gd")
onready var is_tab: PackedScene = preload("res://Preset_Tabs/Internal_Standard_Tab/Internal_Standard_Tab.tscn")
onready var is_tab_resource: Script = preload("res://Preset_Tabs/Internal_Standard_Tab/Internal_Standard_Resource.gd")
onready var cc_tab: PackedScene = preload("res://Preset_Tabs/CalibrationCurve_Tab/Calibration_Curve_Tab.tscn")
onready var preset_saver_resource: Script = preload("res://Presets/PresetSaver.gd")
onready var quick_preset_save_resource: Script = preload("res://UI_Elements/QuickPreset/QuickPresetSave.gd")

onready var file_open_dialog = $FileOpenDialog
onready var main_popup_menu = $MainPopUpMenu
onready var tab_container = $VBoxContainer/ActionMenueContainer/TabContainer
onready var new_preset_warning_dialog = $NewPresetWarningDialog
onready var new_tab_button = $VBoxContainer/TopPartMenueContainer/HBoxContainer/NewTabButton
onready var new_tab_pop_up_menu = $NewTabPopUpMenu
onready var preset_save_dialog = $PresetSaveDialog
onready var preset_load_dialog = $PresetLoadDialog
onready var calculate_button = $VBoxContainer/TopPartMenueContainer/HBoxContainer/CalculateButton
onready var file_save_dialog = $FileSaveDialog
onready var quick_preset_dialog = $QuickPresetDialog
onready var quick_preset_pop_up_menu = $QuickPresetPopUpMenu




enum main_popup_menue_items {
	OPEN_FILE,
	NEW_PRESET,
	LOAD_PRESET,
	SAVE_PRESET,
	CLOSE_PRESET,
	ADD_TO_QUICK_PRESET
}

var main_popup_menue_item_label: Array = [
	"Open file",
	"New preset",
	"Load preset",
	"Save preset",
	"Close preset",
	"Add to quick presets"
]

enum new_tab_popup_menu_items {
	INTERNAL_STANDARD_TAB,
	CALIBRATION_CURVE_TAB
}

var new_tab_popup_menu_item_label: Array = [
	"Internal Standard",
	"Calibration Curve"
]


var file_content: Array = []
var last_opened_preset_path: String = ""

##BUILD UP###########################################

func _ready() -> void:
	add_main_popup_menue_items()
	add_new_tab_popup_menu_items()
	
	create_or_load_quick_preset_safe()
#	Signals.connect("calculation_completed", self, "_on_calculation_completed")
	if debug:
		start_in_debug()


func start_in_debug() -> void:
	_on_FileDialog_file_selected(file_path)
	_on_PresetLoadDialog_file_selected(preset_path)


func add_main_popup_menue_items() -> void:
	var index: int = 0
	for item in main_popup_menue_items.keys():
		main_popup_menu.add_item(main_popup_menue_item_label[index], main_popup_menue_items.get(item))
		index += 1


func add_new_tab_popup_menu_items() -> void:
	var index: int = 0
	for item in new_tab_popup_menu_items.keys():
		new_tab_pop_up_menu.add_item(new_tab_popup_menu_item_label[index], new_tab_popup_menu_items.get(item))
		index += 1


func update_quick_preset_popup_menu() -> void:
	quick_preset_pop_up_menu.clear()
	var preset_info: Array = quick_preset_save.get_preset_info()
	
	for preset in preset_info:
		var slices: PoolStringArray = preset.get("path").rsplit("/")
		var slices2: Array = Array(slices)
		var file_name: String = slices2.back()
		
		quick_preset_pop_up_menu.add_item(file_name, preset.get("id", -100))
		


##LOAD DATA FILE########################################

func _on_FileDialog_file_selected(path) -> void:
	print(path)
	file_content.clear()
	
	var file: File = File.new()
	file.open(path, File.READ)
	
	while file.get_position() < file.get_len():
		var content = file.get_csv_line("	")
		file_content.append(content)
#	var split_content = content.split("	")
	DataManager.set_current_data_sorted_in_rows_string(file_content)
	#Signals.emit_signal("data_received", file_content)
	file.close()


##MAIN MENU############################################

func _on_MenueButton_pressed():
	main_popup_menu.popup()


func _on_MainPopUpMenu_id_pressed(id: int) -> void:
	if id == main_popup_menue_items.OPEN_FILE:
		file_open_dialog.popup()
	if id == main_popup_menue_items.NEW_PRESET:
		setup_new_preset()
	if id == main_popup_menue_items.LOAD_PRESET:
		preset_load_dialog.popup()
	if id == main_popup_menue_items.SAVE_PRESET:
		preset_save_dialog.popup()
	if id == main_popup_menue_items.CLOSE_PRESET:
		delete_all_tabs()
		new_tab_button.hide()
		calculate_button.hide()
	if id == main_popup_menue_items.ADD_TO_QUICK_PRESET:
		quick_preset_dialog.popup()


##CREATE NEW PRESETS###################################

func setup_new_preset() -> void:
	var is_preset_open: bool = check_for_open_preset()
	if is_preset_open:
		new_preset_warning_dialog.popup()
	else:
		create_new_preset()


func _on_NewPresetWarningDialog_confirmed() -> void:
	create_new_preset()


func create_new_preset() -> void:
	delete_all_tabs()
	
	instance_new_tab(main_tab)
	
	new_tab_button.show()
	calculate_button.show()


func instance_new_tab(tab: PackedScene, tab_properties: Array = []) -> void:
	var new_tab: Tabs = tab.instance()
	tab_container.add_child(new_tab)
	
	if tab_properties.empty():
		pass
	else:
		new_tab.set_tab_properties(tab_properties)


func delete_all_tabs() -> void:
	for child in tab_container.get_children():
		child.queue_free()
	return


func check_for_open_preset() -> bool:
	if tab_container.get_child_count() == 0:
		return false
	else: return true


func _on_NewTabButton_pressed() -> void:
	new_tab_pop_up_menu.popup()


func _on_NewTabPopUpMenu_id_pressed(id: int) -> void:
	if id == new_tab_popup_menu_items.INTERNAL_STANDARD_TAB:
		instance_new_tab(is_tab)
	if id == new_tab_popup_menu_items.CALIBRATION_CURVE_TAB:
		instance_new_tab(cc_tab)


##SAVE PRESET###############################################

func _on_PresetSaveDialog_file_selected(path) -> void:
	print(path)
	var new_preset_saver: Resource = preset_saver_resource.new()
	var all_current_preset_properties: Array = gather_all_tab_properties()
	new_preset_saver.set_all_tab_properties(all_current_preset_properties)
	
	if !path.ends_with(".tres"):
		path = path + ".tres"
	
	ResourceSaver.save(path, new_preset_saver, ResourceSaver.FLAG_BUNDLE_RESOURCES)


func gather_all_tab_properties() -> Array:
	var all_properties: Array = []
	for child in tab_container.get_children():
		all_properties.append(child.get_tab_properties())
	return all_properties


##LOAD PRESET ###############################################
func _on_PresetLoadDialog_file_selected(path) -> void:
	print(path)
	if !is_file_a_valid_preset(path):
		return
	load_preset(path)


func load_preset(path: String) -> void:
	last_opened_preset_path = path
	var preset_save: Resource = load(path)
	var tab_properties: Array = preset_save.all_tab_properties.duplicate()#get_all_tab_properties()

	if tab_properties.empty():
		return
		
	delete_all_tabs()
	for props in tab_properties:
		if props[0] == "MAIN":
			instance_new_tab(main_tab, props)
		elif props[0] == "INTERNAL_STANDARD":
			instance_new_tab(is_tab, props)
		elif props[0] == "CALIBRATION_CURVE":
			instance_new_tab(cc_tab, props)
	
	new_tab_button.show()
	calculate_button.show()


func is_file_a_valid_preset(path: String) -> bool:
	if !path.ends_with(".tres"):
		preset_load_dialog.popup()
		return false
		
	var preset_save: Resource = load(path)
	if !preset_save.get("all_tab_properties"):
		preset_load_dialog.popup()
		return false
	return true


func create_or_load_quick_preset_safe() -> void:
	if ResourceLoader.exists(QUICK_PRESET_SAVE_PATH):
		quick_preset_save = load(QUICK_PRESET_SAVE_PATH)#QuickPresetSave.load_save()
		update_quick_preset_popup_menu()
	else:
		quick_preset_save = quick_preset_save_resource.new()


func _on_QuickPresets_pressed() -> void:
	quick_preset_pop_up_menu.popup()


func _on_QuickPresetDialog_file_selected(path) -> void:
	if !is_file_a_valid_preset(path):
		return
	quick_preset_save.add_preset_path(path)
	update_quick_preset_popup_menu()
	ResourceSaver.save(QUICK_PRESET_SAVE_PATH, quick_preset_save, ResourceSaver.FLAG_BUNDLE_RESOURCES)


func _on_QuickPresetPopUpMenu_id_pressed(id) -> void:
	var preset_infos: Array = quick_preset_save.get_preset_info()
	
	for preset in preset_infos:
		if preset.get("id") == id:
			load_preset(preset.get("path"))


##CALCULATION PROCESS#############################################

func _on_CalculateButton_pressed() -> void:
	file_save_dialog.popup()


func _on_FileSaveDialog_file_selected(path):
	if !path.ends_with(".txt"):
		path = path + ".txt"
	Signals.emit_signal("path_for_calculation_selected", path)


func _on_calculation_completed() -> void:
	load_preset(last_opened_preset_path)







