extends Tabs
class_name MainTab

onready var series_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SeriesNameContainer/SeriesNameEdit
onready var compound_class_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CompoundClassContainer/CompoundClassEdit
onready var extraction_volume_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeContainer/ExtractionVolumeEdit
onready var masses_column_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/MassesColumnContainer/MassesColumnEdit
onready var column_selection_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ColumnSelectionContainer/ColumnSelectionButton



var tab_class: String = "MAIN"
var series_name: String = ""
var compound_class: String = ""
var extraction_volume: float = 0.0
var masses_column_name: String = ""

var tab_properties: Array = [
	tab_class,
	series_name,
	compound_class,
	extraction_volume,
	masses_column_name,
] setget set_tab_properties, get_tab_properties

enum column_selection_mode {
	DIRECTLY_AFTER_SAMPLE,
	AFTER_ALL_SAMPLES,
}

var column_selection_mode_label: Array = [
	"directly after sample",
	"after all samples (same order)",
]

func _ready():
	name = "Main"
	
	add_items_for_selection_button()


func add_items_for_selection_button() -> void:
	var index: int = 0
	for item in column_selection_mode.keys():
		column_selection_button.add_item(column_selection_mode_label[index], column_selection_mode.get(item))
		index += 1


func _on_SeriesNameEdit_text_changed(new_text):
	series_name = new_text
	tab_properties[1] = new_text


func _on_CompoundClassEdit_text_changed(new_text):
	compound_class = new_text
	tab_properties[2] = new_text


func _on_ExtractionVolumeEdit_text_changed(new_text):
	extraction_volume = float(new_text)
	tab_properties[3] = float(new_text)


func _on_MassesColumnEdit_text_changed(new_text):
	masses_column_name = new_text
	tab_properties[4] = new_text


func set_up_values() -> void:
	series_name = tab_properties[1]
	compound_class = tab_properties[2]
	extraction_volume = tab_properties[3]
	masses_column_name = tab_properties[4]


func update_line_edits() -> void:
	series_name_edit.text = series_name
	compound_class_edit.text = compound_class
	extraction_volume_edit.text = str(extraction_volume)
	masses_column_edit.text = masses_column_name



###########################

func set_tab_properties(new_properties: Array) -> void:
	tab_properties = new_properties
	set_up_values()
	update_line_edits()


func get_tab_properties() -> Array:
	return tab_properties
