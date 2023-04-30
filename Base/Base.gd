extends Control

onready var main_tab: PackedScene = preload("res://Preset_Tabs/Main_Tab/Main_Tab.tscn")
onready var main_tab_resource: Script = preload("res://Preset_Tabs/Main_Tab/Main_Tab_Resource.gd")
onready var is_tab: PackedScene = preload("res://Preset_Tabs/Internal_Standard_Tab/Internal_Standard_Tab.tscn")
onready var is_tab_resource: Script = preload("res://Preset_Tabs/Internal_Standard_Tab/Internal_Standard_Resource.gd")


onready var file_open_dialog = $FileOpenDialog
onready var main_popup_menu = $MainPopUpMenu
onready var tab_container = $VBoxContainer/ActionMenueContainer/TabContainer
onready var new_preset_warning_dialog = $NewPresetWarningDialog
onready var new_tab_button = $VBoxContainer/TopPartMenueContainer/HBoxContainer/NewTabButton
onready var new_tab_pop_up_menu = $NewTabPopUpMenu
onready var preset_save_dialog = $PresetSaveDialog



enum main_popup_menue_items {
	OPEN_FILE,
	NEW_PRESET,
	LOAD_PRESET,
	SAVE_PRESET,
}

var main_popup_menue_item_label: Array = [
	"Open file",
	"New preset",
	"Load preset",
	"Save preset",
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


func _ready() -> void:
	add_main_popup_menue_items()
	add_new_tab_popup_menu_items()


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
	
	
func _on_FileDialog_file_selected(path) -> void:
	#print(path)
	var file: File = File.new()
	file.open(path, File.READ)
	
	while file.get_position() < file.get_len():
		var content = file.get_csv_line("	")
		file_content.append(content)
#	var split_content = content.split("	")
	#print(file_content)
	Signals.emit_signal("data_received", file_content)


func _on_MenueButton_pressed():
	main_popup_menu.popup()


func _on_MainPopUpMenu_id_pressed(id: int) -> void:
	if id == main_popup_menue_items.OPEN_FILE:
		file_open_dialog.popup()
	if id == main_popup_menue_items.NEW_PRESET:
		setup_new_preset()
	if id == main_popup_menue_items.LOAD_PRESET:
		pass
	if id == main_popup_menue_items.SAVE_PRESET:
		preset_save_dialog.popup()




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
	
	instance_new_tab(main_tab, main_tab_resource)
	
	new_tab_button.show()


func instance_new_tab(tab: PackedScene, tab_resource: Script) -> void:
	var new_tab: Tabs = tab.instance()
	tab_container.add_child(new_tab)
	
	var new_tab_resource: Resource = tab_resource.new()
	new_tab.set_tab_resource(new_tab_resource)


func delete_all_tabs() -> void:
	for child in tab_container.get_children():
		child.queue_free()


func check_for_open_preset() -> bool:
	if tab_container.get_child_count() == 0:
		return false
	else: return true


func _on_NewTabButton_pressed() -> void:
	new_tab_pop_up_menu.popup()


func _on_NewTabPopUpMenu_id_pressed(id: int) -> void:
	if id == new_tab_popup_menu_items.INTERNAL_STANDARD_TAB:
		instance_new_tab(is_tab, is_tab_resource)
	if id == new_tab_popup_menu_items.CALIBRATION_CURVE_TAB:
		pass


func _on_PresetSaveDialog_file_selected(path):
	print(path)
