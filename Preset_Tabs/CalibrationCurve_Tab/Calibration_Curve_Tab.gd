extends Tabs
class_name CalibrationCurveTab

onready var tab_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/TabNameContainer/TabNameEdit
onready var compound_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CompoundNameContainer2/CompoundNameEdit
onready var column_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ColumnNameContainer/ColumnNameEdit
onready var curve_concentration_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveConcentrationsContainer/CurveConcentrationEdit
onready var curve_rows_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveRowsContainer/CurveRowsEdit
onready var curve_style_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CurveStyleContainer/CurveStyleButton


var tab_class: String = "CALIBRATION_CURVE"
var tab_name: String = "" #setget set_tab_name
var compound_name: String = ""
var column_name: String = ""
var curve_concentrations: Array = []
var curve_rows: Array = []
var curve_style: int = 0

var tab_properties: Array = [
	tab_class,
	tab_name,
	compound_name,
	column_name,
	curve_concentrations,
	curve_rows,
	curve_style
] setget set_tab_properties, get_tab_properties

enum curve_styles {
	ORIGIN_INTERCEPT,
	INTERCEPT,
}

var curve_styles_labels: Array = [
	"origin intercept",
	"intercept"
]

func _ready():
	Signals.connect("calculation_info_needed", self, "on_calculation_info_needed")
	add_items_for_curve_style_button()


func add_items_for_curve_style_button() -> void:
	var index: int = 0
	for item in curve_styles.keys():
		curve_style_button.add_item(curve_styles_labels[index], curve_styles.get(item))
		index += 1


func _on_TabNameEdit_text_changed(new_text):
	tab_name = new_text
	name = new_text
	tab_properties[1] = new_text


func _on_CompoundNameEdit_text_changed(new_text):
	compound_name = new_text
	tab_properties[2] = new_text


func _on_ColumnNameEdit_text_changed(new_text):
	column_name = new_text
	tab_properties[3] = new_text


func _on_CurveConcentrationEdit_text_changed(new_text):
	curve_concentrations.clear()
	var split: PoolStringArray = curve_concentration_edit.text.rsplit(",")
	for number in split:
		curve_concentrations.append(float(number))
	tab_properties[4] = curve_concentrations


func _on_CurveRowsEdit_text_changed(new_text):
	curve_rows.clear()
	var split: PoolStringArray = new_text.rsplit(",")
	for number in split:
		curve_rows.append(int(number))
	tab_properties[5] = curve_rows


func _on_CurveStyleButton_item_selected(index):
	curve_style = index
	tab_properties[6] = curve_style



func set_up_values() -> void:
	tab_name = tab_properties[1]
	compound_name = tab_properties[2]
	column_name = tab_properties[3]
	curve_concentrations = tab_properties[4]
	curve_rows = tab_properties[5]
	curve_style = tab_properties[6]


func update_line_edits() -> void:
	tab_name_edit.text = tab_name
	name = tab_name
	compound_name_edit.text = compound_name
	column_name_edit.text = column_name
	curve_concentration_edit.text = transform_to_string(curve_concentrations)
	curve_rows_edit.text = transform_to_string(curve_rows)
	curve_style_button._select_int(curve_style)


func transform_to_string(curve_concentrations: Array) -> String:
	var curve_conc_string: String = ""
	for number_index in curve_concentrations.size():
		if number_index == 0:
			curve_conc_string += String(curve_concentrations[number_index])
		else:
			curve_conc_string += ", " + String(curve_concentrations[number_index])
	return curve_conc_string


func on_calculation_info_needed() -> void:
	print(typeof(curve_concentrations[0]), " ", typeof(curve_rows[0]))
	Signals.emit_signal("send_cc_data_for_calculation", [tab_class, column_name, curve_concentrations, curve_rows, curve_style])

########################################

func set_tab_properties(new_properties: Array) -> void:
	tab_properties = new_properties
	set_up_values()
	update_line_edits()


func get_tab_properties() -> Array:
	return tab_properties








