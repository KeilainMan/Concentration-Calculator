extends Tabs
class_name InternalStandardTab

onready var close_tab_popup_menu: PackedScene = preload("res://UI_Elements/CloseTabPopUpMenu.tscn")

onready var tab_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/TabNameContainer/TabNameEdit
onready var compound_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CompoundNameContainer2/CompoundNameEdit
onready var is_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ISNameContainer/ISNameEdit
onready var is_abbreviation_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ISAbbreviationContainer2/ISAbbreviationEdit
onready var is_concentration_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ISContainer/ISConcentrationEdit
onready var is_response_factor_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ResponseFactorContainer/ISResponseFactorEdit
onready var column_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ColumnNameContainer/ColumnNameEdit


var tab_class: String = "INTERNAL_STANDARD"
var tab_name: String = "" #setget set_tab_name
var compound_name: String = ""
var is_name: String = ""
var is_abbreviation: String = ""
var is_concentration: float = 0.0
var response_factor: float = 1
var column_name: String = ""

var tab_properties: Array = [
	tab_class,
	tab_name,
	compound_name,
	is_name,
	is_abbreviation,
	is_concentration,
	response_factor,
	column_name,
] setget set_tab_properties, get_tab_properties

onready var tab_manager
onready var focused: bool = false setget set_focused, get_focused

signal preset_tab_tree_exited



func _ready():
	tab_manager = get_tree().get_nodes_in_group("base")[0]
	Signals.connect("calculation_info_needed", self, "on_calculation_info_needed")
	Signals.emit_signal("can_be_registered_for_summary", self)
	connect("preset_tab_tree_exited", tab_manager, "_on_preset_tab_tree_exited")


func _on_TabNameEdit_text_changed(new_text):
	tab_name = new_text
	name = new_text
	tab_properties[1] = new_text
	_on_stat_changed()


func _on_CompoundNameEdit_text_changed(new_text):
	compound_name = new_text
	tab_properties[2] = new_text
	_on_stat_changed()


func _on_ISNameEdit_text_changed(new_text):
	is_name = new_text
	tab_properties[3] = new_text


func _on_ISAbbreviationEdit_text_changed(new_text):
	is_abbreviation = new_text
	tab_properties[4] = new_text
	_on_stat_changed()


func _on_ISConcentrationEdit_text_changed(new_text):
	is_concentration = float(new_text)
	tab_properties[5] = float(new_text)
	_on_stat_changed()


func _on_ISResponseFactorEdit_text_changed(new_text):
	response_factor = float(new_text)
	tab_properties[6] = float(new_text)
	_on_stat_changed()


func _on_ColumnNameEdit_text_changed(new_text):
	column_name = new_text
	tab_properties[7] = new_text
	_on_stat_changed()


func set_up_values() -> void:
	tab_name = tab_properties[1]
	compound_name = tab_properties[2]
	is_name = tab_properties[3]
	is_abbreviation = tab_properties[4]
	is_concentration = tab_properties[5]
	response_factor = tab_properties[6]
	column_name = tab_properties[7]


func update_line_edits() -> void:
	tab_name_edit.text = tab_name
	name = tab_name
	compound_name_edit.text = compound_name
	is_name_edit.text = is_name
	is_concentration_edit.text = str(is_concentration)
	is_abbreviation_edit.text = is_abbreviation
	is_response_factor_edit.text = str(response_factor)
	column_name_edit.text = column_name
	_on_stat_changed()


func on_calculation_info_needed() -> void:
	Signals.emit_signal("send_is_data_for_calculation", [tab_class, column_name, is_concentration, response_factor])


###################################################
## Summary Functions ##

func _on_stat_changed() -> void:
	var summary_stats: Array = [
		tab_name,
		compound_name,
		is_abbreviation,
		is_concentration,
		response_factor,
		column_name]
	SummaryManager.update_is_summary(summary_stats, self)




func _on_ISTab_tree_exited() -> void:
	emit_signal("preset_tab_tree_exited")


###################################################

func set_tab_properties(new_properties: Array) -> void:
	tab_properties = new_properties
	set_up_values()
	update_line_edits()


func get_tab_properties() -> Array:
	return tab_properties


func set_focused(value: bool) -> void:
	focused = value


func get_focused() -> bool:
	return focused


################################################################################
## Close Tab ##

func _on_close_this_tab() -> void:
	queue_free()
	
################################################################################
## Input ##

func _input(event: InputEvent) -> void:
	if focused:
		if event.is_action_pressed("mouse_button_right"):
			print("Mouseclick")
			var new_popup: PopupMenu = close_tab_popup_menu.instance()
			add_child(new_popup)


