extends Tabs
class_name Internal_Standard_Tab

onready var compound_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CompoundNameContainer2/CompoundNameEdit
onready var is_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ISNameContainer/ISNameEdit
onready var is_abbreviation_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ISAbbreviationContainer2/ISAbbreviationEdit
onready var is_concentration_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ISContainer/ISConcentrationEdit
onready var is_response_factor_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ResponseFactorContainer/ISResponseFactorEdit
onready var column_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ColumnNameContainer/ColumnNameEdit



var tab_resource: Resource setget set_tab_resource

var tab_name: String = "" setget set_tab_name
var compound_name: String = ""
var is_name: String = ""
var is_abbreviation: String = ""
var is_concentration: float = 0.0
var response_factor: int = 1
var column_name: String = ""



func init(resource: Resource) -> void:
	set_tab_resource(resource)


func _ready():
	pass

func _on_CompoundNameEdit_text_changed(new_text):
	compound_name = new_text
	save_to_resource()


func _on_ISNameEdit_text_changed(new_text):
	is_name = new_text
	save_to_resource()


func _on_ISAbbreviationEdit_text_changed(new_text):
	is_abbreviation = new_text
	save_to_resource()


func _on_ISConcentrationEdit_text_changed(new_text):
	is_concentration = float(new_text)
	save_to_resource()


func _on_ISResponseFactorEdit_text_changed(new_text):
	response_factor = int(new_text)
	save_to_resource()


func _on_ColumnNameEdit_text_changed(new_text):
	column_name = new_text
	save_to_resource()


func set_up_values() -> void:
	tab_name = tab_resource.tab_name
	compound_name = tab_resource.compound_name
	is_name = tab_resource.is_name
	is_abbreviation = tab_resource.is_abbreviation
	is_concentration = tab_resource.is_concentration
	response_factor = tab_resource.responde_factor
	column_name = tab_resource.column_name


func update_line_edits() -> void:
	compound_name_edit.text = compound_name
	is_name_edit.text = is_name
	is_concentration_edit.text = str(is_concentration)
	is_abbreviation_edit.text = is_abbreviation
	is_response_factor_edit.text = str(response_factor)
	column_name_edit.text = column_name


func save_to_resource() -> void:
	tab_resource.tab_name = tab_name
	tab_resource.compound_name = compound_name
	tab_resource.is_name = is_name
	tab_resource.is_abbreviation = is_abbreviation
	tab_resource.is_concentration = is_concentration
	tab_resource.response_factor = response_factor
	tab_resource.column_name = column_name



########################################

func set_tab_name(new_name: String) -> void:
	tab_name = new_name
	name = tab_name
	save_to_resource()


func set_tab_resource(new_resource: Resource) -> void:
	tab_resource = new_resource
	set_up_values()
	update_line_edits()



