extends Tabs
class_name InternalStandardTab

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
var response_factor: int = 1
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



func _ready():
	Signals.connect("calculation_info_needed", self, "on_calculation_info_needed")


func _on_TabNameEdit_text_changed(new_text):
	print("changed")
	tab_name = new_text
	name = new_text
	tab_properties[1] = new_text


func _on_CompoundNameEdit_text_changed(new_text):
	compound_name = new_text
	tab_properties[2] = new_text


func _on_ISNameEdit_text_changed(new_text):
	is_name = new_text
	tab_properties[3] = new_text


func _on_ISAbbreviationEdit_text_changed(new_text):
	is_abbreviation = new_text
	tab_properties[4] = new_text


func _on_ISConcentrationEdit_text_changed(new_text):
	is_concentration = float(new_text)
	tab_properties[5] = float(new_text)


func _on_ISResponseFactorEdit_text_changed(new_text):
	response_factor = int(new_text)
	tab_properties[6] = int(new_text)


func _on_ColumnNameEdit_text_changed(new_text):
	column_name = new_text
	tab_properties[7] = new_text


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


func on_calculation_info_needed() -> void:
	Signals.emit_signal("send_is_data_for_calculation", [tab_class, column_name, is_concentration, response_factor])

########################################

func set_tab_properties(new_properties: Array) -> void:
	tab_properties = new_properties
	set_up_values()
	update_line_edits()


func get_tab_properties() -> Array:
	return tab_properties




