extends Control

## debug setting
export var debug: bool = false
export var file_path: String = ""
export var preset_path: String = ""

var quick_preset_save: Resource
const QUICK_PRESET_SAVE_PATH: String = "user://quick_preset_save.tres"
onready var quick_preset_save_name: String = "quick_preset_save.tres"
onready var save_folder_name: String = "saves"
onready var save_folder_path: String = ""

onready var main_tab: PackedScene = preload("res://Preset_Tabs/Main_Tab/Main_Tab.tscn")
onready var is_tab: PackedScene = preload("res://Preset_Tabs/Internal_Standard_Tab/Internal_Standard_Tab.tscn")
onready var cc_tab: PackedScene = preload("res://Preset_Tabs/CalibrationCurve_Tab/Calibration_Curve_Tab.tscn")
onready var preset_saver_resource: Script = preload("res://Presets/PresetSaver.gd")
onready var quick_preset_save_resource: Script = preload("res://UI_Elements/QuickPreset/QuickPresetSave.gd")

onready var file_open_dialog = $FileOpenDialog
onready var main_menu_button: MenuButton = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/FileBlock/MenuButton
onready var quick_presets_button: MenuButton = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/PresetBlock/QuickPresetsButton
onready var tab_container = $VBoxContainer/ActionMenueContainer/TabContainer
onready var new_preset_warning_dialog = $NewPresetWarningDialog
onready var new_tab_button: MenuButton = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/PresetBlock/NewTabButton
onready var close_sample_file_button: Button = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/FileBlock/CloseSampleFileButton
onready var preset_save_dialog = $PresetSaveDialog
onready var preset_load_dialog = $PresetLoadDialog
onready var summary_button: Button = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/PresetBlock/SummaryButton
onready var calculate_button: MenuButton = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/PresetBlock/CalculateButton
onready var file_save_dialog_txt: FileDialog = $FileSaveDialogTxt
onready var file_save_dialog_xlsx: FileDialog = $FileSaveDialogXlsx
onready var file_save_dialog_xlsx_ws: FileDialog = $FileSaveDialogXlsxWS
onready var quick_preset_dialog = $QuickPresetDialog
onready var popup_layer: CanvasLayer = $PopupLayer
onready var summary_layer: CanvasLayer = $SummaryLayer
onready var close_preset_button: Button = $VBoxContainer/TextureRect/TopPartMenueContainer/HBoxContainer/PresetBlock/ClosePresetButton



enum main_popup_menue_items {
	OPEN_FILE,
	NEW_PRESET,
	LOAD_PRESET,
	SAVE_PRESET,
	CLOSE_PRESET,
	ADD_TO_QUICK_PRESET
}

var main_popup_menue_item_label: Array = [
	"Open sample file",
	"New preset",
	"Open preset",
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
var summary_is_opened: bool = false

var current_preset_tab_count: int = 0
var destruction_preset_tab_count: int = 0
var temp_tab_properties: Array = []


################################################################################
##BUILD UP###########################################

func _ready() -> void:
	add_main_popup_menu_items()
	add_new_tab_popup_menu_items()
	
	create_or_load_quick_preset_safe()
	PopUpManager.set_popup_parent_node(popup_layer)
	
	main_menu_button.get_popup().connect("id_pressed", self, "_on_MainPopUpMenu_id_pressed")
	quick_presets_button.get_popup().connect("id_pressed", self, "_on_QuickPresetPopUpMenu_id_pressed")
	new_tab_button.get_popup().connect("id_pressed", self, "_on_NewTabPopUpMenu_id_pressed")
	calculate_button.get_popup().connect("id_pressed", self, "_on_CalculateButton_id_pressed")
#	Signals.connect("calculation_completed", self, "_on_calculation_completed")

	
	
	if debug:
		start_in_debug()


func start_in_debug() -> void:
	_on_FileDialog_file_selected(file_path)
	_on_PresetLoadDialog_file_selected(preset_path)


func add_main_popup_menu_items() -> void:
	var index: int = 0
	for item in main_popup_menue_items.keys():
		main_menu_button.get_popup().add_item(main_popup_menue_item_label[index], main_popup_menue_items.get(item))
		index += 1


func add_new_tab_popup_menu_items() -> void:
	var index: int = 0
	for item in new_tab_popup_menu_items.keys():
		new_tab_button.get_popup().add_item(new_tab_popup_menu_item_label[index], new_tab_popup_menu_items.get(item))
		index += 1


func update_quick_preset_popup_menu() -> void:
	quick_presets_button.get_popup().clear()
	var preset_info: Array = quick_preset_save.get_preset_info()
	
	for preset in preset_info:
		var slices: PoolStringArray = preset.get("path").rsplit("/")
		var slices2: Array = Array(slices)
		var file_name: String = slices2.back()
		
		quick_presets_button.get_popup().add_item(file_name, preset.get("id", -100))


################################################################################
##LOAD DATA FILE##

func _on_FileDialog_file_selected(path) -> void:
	print(path)
	DataManager.set_file_path(path)
	close_sample_file_button.show()


func _on_OpenSampleFileButton_pressed() -> void:
	file_open_dialog.popup()


################################################################################
##MAIN MENU##

#func _on_MenueButton_pressed():
#	main_popup_menu.popup()


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
		delete_all_tabs("NULL")
		new_tab_button.hide()
		close_preset_button.hide()
		summary_button.hide()
		SummaryManager.clear_summary()
		calculate_button.hide()
	if id == main_popup_menue_items.ADD_TO_QUICK_PRESET:
		quick_preset_dialog.popup()


################################################################################
##CLOSE SAMPLE FILE##

func _on_CloseSampleFileButton_pressed() -> void:
	Signals.emit_signal("data_deleted")
	close_sample_file_button.hide()


################################################################################
##CREATE NEW PRESETS##

func setup_new_preset() -> void:
	var is_preset_open: bool = check_for_open_preset()
	if is_preset_open:
		new_preset_warning_dialog.popup()
	else:
		create_new_preset()


func _on_NewPresetWarningDialog_confirmed() -> void:
	create_new_preset()


func create_new_preset() -> void:
	delete_all_tabs("CREATE")


func instance_new_raw_preset() -> void:
	instance_new_tab(main_tab)
	new_tab_button.show()
	close_preset_button.show()
	summary_button.show()
	calculate_button.show()


################################################################################
## PRESET TAB INSTANCING ##

func instance_new_tab(tab: PackedScene, tab_properties: Array = []) -> void:
	var new_tab: Tabs = tab.instance()
	tab_container.add_child(new_tab)
	
	if tab_properties.empty():
		pass
	else:
		new_tab.set_tab_properties(tab_properties)


################################################################################
## DELETION OF ALL PRESET TABS ##

func delete_all_tabs(callback: String) -> void:
	if tab_container.get_child_count() == 0: #triggers if a no preset was loaded
		match callback:
			"CREATE":
				instance_new_raw_preset() #instances a new preset (only main tab)
			"LOAD":
				instance_current_tab_properties() #instances a loaded preset
		return
	for child in tab_container.get_children(): #triggers if a preset was loaded
		print("queue all tabs free: ", child)
		child.queue_free()
	return


func _on_preset_tab_tree_exited() -> void:
	destruction_preset_tab_count += 1
	print(destruction_preset_tab_count, " | ", current_preset_tab_count)
	if destruction_preset_tab_count == current_preset_tab_count:
		current_preset_tab_count = 0
		instance_current_tab_properties()
		destruction_preset_tab_count = 0


func instance_current_tab_properties() -> void:
	for props in temp_tab_properties:
		if props[0] == "MAIN":
			instance_new_tab(main_tab, props)
		elif props[0] == "INTERNAL_STANDARD":
			instance_new_tab(is_tab, props)
		elif props[0] == "CALIBRATION_CURVE":
			instance_new_tab(cc_tab, props)
		current_preset_tab_count += 1
	temp_tab_properties.clear()


func check_for_open_preset() -> bool:
	if tab_container.get_child_count() == 0:
		return false
	else: return true


func _on_NewTabPopUpMenu_id_pressed(id: int) -> void:
	if id == new_tab_popup_menu_items.INTERNAL_STANDARD_TAB:
		instance_new_tab(is_tab)
	if id == new_tab_popup_menu_items.CALIBRATION_CURVE_TAB:
		instance_new_tab(cc_tab)





################################################################################
##SAVE PRESET##

func _on_PresetSaveDialog_file_selected(path) -> void:
	print(path)
	var new_preset_saver: Resource = preset_saver_resource.new()
	var all_current_preset_properties: Array = gather_all_tab_properties()
	new_preset_saver.set_all_tab_properties(all_current_preset_properties)
	
	if !path.ends_with(".tres"):
		path = path + ".tres"
	
	var error = ResourceSaver.save(path, new_preset_saver)#, ResourceSaver.FLAG_BUNDLE_RESOURCES)
	if !error == OK:
		PopUpManager.show_error_popup(error)


func gather_all_tab_properties() -> Array:
	var all_properties: Array = []
	for child in tab_container.get_children():
		all_properties.append(child.get_tab_properties())
	return all_properties


################################################################################
##LOAD PRESET ##

func _on_PresetLoadDialog_file_selected(path) -> void:
	print(path)
	if !is_file_a_valid_preset(path):
		return
	else:
		load_preset(path)


func load_preset(path: String) -> void:
	SummaryManager.clear_summary()
	SummaryManager.clear_registered_tabs()
	
	last_opened_preset_path = path
	var preset_save: Resource = load(path)
	var tab_properties: Array = preset_save.all_tab_properties.duplicate()#get_all_tab_properties()

	if tab_properties.empty():
		return
	
	temp_tab_properties = tab_properties
	delete_all_tabs("LOAD")

	new_tab_button.show()
	close_preset_button.show()
	summary_button.show()
	calculate_button.show()


func is_file_a_valid_preset(path: String) -> bool:
	if !path.ends_with(".tres"):
		print("Path is not valid")
		preset_load_dialog.popup()
		return false
		
	var preset_save: Resource = load(path)
	if preset_save.get("all_tab_properties") == null:
		print("Preset isn't right configured")
		preset_load_dialog.popup()
		return false
	return true


func create_or_load_quick_preset_safe() -> void:
	var temp_path = OS.get_executable_path().get_base_dir().plus_file(save_folder_name)
	var directory: Directory = Directory.new()
	print("directory created")
	if directory.dir_exists(temp_path):
		print("directory exists")
		save_folder_path = temp_path
		if ResourceLoader.exists(temp_path.plus_file(quick_preset_save_name)):
			quick_preset_save = load(temp_path.plus_file(quick_preset_save_name))
			update_quick_preset_popup_menu()
			print("resource loaded")
		else:
			quick_preset_save = quick_preset_save_resource.new()
			print("resource created")
	else:
		directory.make_dir(temp_path)
		save_folder_path = temp_path
		quick_preset_save = quick_preset_save_resource.new()
		print("directory created2")

#	if ResourceLoader.exists(QUICK_PRESET_SAVE_PATH):
#		quick_preset_save = load(QUICK_PRESET_SAVE_PATH)#QuickPresetSave.load_save()
#		update_quick_preset_popup_menu()
#	else:
#		quick_preset_save = quick_preset_save_resource.new()


func _on_QuickPresetDialog_file_selected(path) -> void:
	if !is_file_a_valid_preset(path):
		PopUpManager.show_popup(7)
		return
	quick_preset_save.add_preset_path(path)
	update_quick_preset_popup_menu()
	ResourceSaver.save(save_folder_path.plus_file(quick_preset_save_name), quick_preset_save)# ResourceSaver.FLAG_BUNDLE_RESOURCES)
#	var error: int = 
#
#	if !error == OK:
#		PopUpManager.show_error_popup(error)


func _on_QuickPresetPopUpMenu_id_pressed(id: int) -> void:
	var preset_infos: Array = quick_preset_save.get_preset_info()
	
	for preset in preset_infos:
		if preset.get("id") == id:
			var new_file: File = File.new()
			if new_file.file_exists(preset.get("path")):
				load_preset(preset.get("path"))
			else:
				PopUpManager.show_error_popup("File doesn't exist!")

################################################################################
##PRESET NAVIGATION##


func _on_TabContainer_tab_selected(tab: int) -> void:
	if tab_container.get_tab_count() > 1:
		if !tab_container.get_child(tab_container.get_previous_tab()).tab_class == "MAIN":
			tab_container.get_child(tab_container.get_previous_tab()).set_focused(false)
	if !tab_container.get_child(tab).tab_class == "MAIN":
		tab_container.get_child(tab).set_focused(true)


func _on_OpenPresetButton_pressed() -> void:
	preset_load_dialog.popup()


func _on_ClosePresetButton_pressed() -> void:
	delete_all_tabs("NULL")
	new_tab_button.hide()
	close_preset_button.hide()
	summary_button.hide()
	SummaryManager.clear_summary()
	calculate_button.hide()


func _on_NewPresetButton_pressed() -> void:
	setup_new_preset()

################################################################################
##SUMMARY##

func _on_SummaryButton_pressed() -> void:
	if summary_is_opened:
		summary_is_opened = false
	else:
		summary_is_opened = true
	if summary_is_opened:
		summary_layer.show()
	else:
		summary_layer.hide()


################################################################################
##CALCULATION PROCESS##

func _on_CalculateButton_id_pressed(id: int) -> void:
	match id:
		0:
			file_save_dialog_txt.popup()
		1:
			file_save_dialog_xlsx.popup()
		2: 
			file_save_dialog_xlsx_ws.popup()


func _on_FileSaveDialogTxt_file_selected(path: String) -> void:
	if !path.ends_with(".txt"):
		path = path + ".txt"
	Signals.emit_signal("path_for_calculation_selected", path, "TXT")


func _on_FileSaveDialogXlsx_file_selected(path: String) -> void:
	if !path.ends_with(".xlsx"):
		path = path + ".xlsx"
	Signals.emit_signal("path_for_calculation_selected", path, "XLSX")


func _on_FileSaveDialogXlsxWS_file_selected(path: String) -> void:
	if !path.ends_with(".xlsx"):
		path = path + ".xlsx"
	Signals.emit_signal("path_for_calculation_selected", path, "XLSXWS")


func _on_calculation_completed() -> void:
	load_preset(last_opened_preset_path)
















