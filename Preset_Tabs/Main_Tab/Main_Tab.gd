extends Tabs
class_name MainTab

onready var series_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SeriesNameContainer/SeriesNameEdit
onready var series_info_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SeriesInfoContainer/SeriesInfoEdit
onready var extraktion_volume_selection_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeSelectionContainer2/ExtraktionVolumeSelectionButton
onready var extraction_volume_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeContainer/ExtractionVolumeEdit
onready var extraction_volume_column_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeColumnNameContainer/ExtractionVolumeColumnNameEdit
onready var normalization_selection_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/NormalizationSelectionContainer/NormalizationSelectionButton
onready var normalizer_column_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/NormalizerColumnNameContainer/NormalizerColumnNameEdit
onready var input_mode_selection_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/InputModeContainer/InputModeSelectionButton
onready var sample_area_column_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SampleAreaColumnContainer/SampleAreaColumnEdit
onready var internal_standard_area_column_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/InternalStandardAreaColumnContainer/InternalStandardAreaColumnEdit
onready var header_selection_button = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/HeaderSelectionContainer/HeaderSelectionButton
onready var sample_name_column_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SampleNameColumnContainer/SampleNameColumnEdit
onready var sample_name_sheet_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SampleNameSheetNameContainer/SampleNameSheetNameEdit

onready var normalizer_column_name_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/NormalizerColumnNameContainer
onready var sample_area_column_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SampleAreaColumnContainer
onready var internal_standard_area_column_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/InternalStandardAreaColumnContainer
onready var header_selection_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/HeaderSelectionContainer
onready var extraction_volume_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeContainer
onready var extraction_volume_column_name_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeColumnNameContainer
onready var sample_name_column_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SampleNameColumnContainer
onready var sample_name_sheet_name_container = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SampleNameSheetNameContainer

var tab_class: String = "MAIN"
var series_name: String = ""
var series_info: String = ""
var varying_extraction_volumes: int = 0
var extraction_volume: float = 0.0
var extraction_volume_column_name: String = ""
var normalization: int = 0
var masses_column_name: String = ""
var input_mode: int = 0
var sample_name_column: int = 1
var sample_name_sheet_name: String = ""
var sample_area_column: int = 1
var internal_standard_area_column: int = 2
var header: int = 0

var tab_properties: Array = [
	tab_class,
	series_name,
	series_info,
	varying_extraction_volumes,
	extraction_volume,
	extraction_volume_column_name,
	normalization,
	masses_column_name,
	input_mode,
	sample_name_column,
	sample_name_sheet_name,
	sample_area_column,
	internal_standard_area_column,
	header
] setget set_tab_properties, get_tab_properties

onready var tab_manager

signal preset_tab_tree_exited

func _ready():
	name = "Main"
	tab_manager = get_tree().get_nodes_in_group("base")[0]
	
	Signals.connect("calculation_info_needed", self, "on_calculation_info_needed")
	connect("preset_tab_tree_exited", tab_manager, "_on_preset_tab_tree_exited")
	
	extraktion_volume_selection_button.emit_signal("item_selected", varying_extraction_volumes)
	normalization_selection_button.emit_signal("item_selected", normalization)
	input_mode_selection_button.emit_signal("item_selected", input_mode)

func _on_SeriesNameEdit_text_changed(new_text: String) -> void:
	series_name = new_text
	tab_properties[1] = new_text
	_on_stat_changed()


func _on_SeriesInfoEdit_text_changed(new_text: String) -> void:
	series_info = new_text
	tab_properties[2] = new_text
	_on_stat_changed()

func _on_ExtraktionVolumeSelectionButton_item_selected(index: int) -> void:
	varying_extraction_volumes = index
	tab_properties[3] = index
	
	if varying_extraction_volumes == 0:
		extraction_volume_column_name_container.show()
		extraction_volume_container.hide()
	else:
		extraction_volume_column_name_container.hide()
		extraction_volume_container.show()
	_on_stat_changed()


func _on_ExtractionVolumeEdit_text_changed(new_text: String) -> void:
	extraction_volume = float(new_text)
	tab_properties[4] = float(new_text)
	_on_stat_changed()


func _on_ExtractionVolumeColumnNameEdit_text_changed(new_text: String) -> void:
	extraction_volume_column_name = new_text
	tab_properties[5] = new_text
	_on_stat_changed()


func _on_NormalizationSelectionButton_item_selected(index: int) -> void:
	normalization = index
	tab_properties[6] = index
	
	if normalization == 0:
		normalizer_column_name_container.show()
	else:
		normalizer_column_name_container.hide()
	_on_stat_changed()


func _on_NormalizerColumnNameEdit_text_changed(new_text: String) -> void:
	masses_column_name = new_text
	tab_properties[7] = new_text
	_on_stat_changed()


func _on_InputModeSelectionButton_item_selected(index: int) -> void:
	input_mode = index
	tab_properties[8] = index
	
	if input_mode == 0:
		sample_name_column_container.show()
		sample_name_sheet_name_container.hide()
		sample_area_column_container.hide()
		internal_standard_area_column_container.hide()
		header_selection_container.hide()
	elif input_mode == 1:
		sample_name_column_container.show()
		sample_name_sheet_name_container.show()
		sample_area_column_container.show()
		internal_standard_area_column_container.show()
		header_selection_container.show()
	else:
		return
	_on_stat_changed()


func _on_SampleNameColumnEdit_text_changed(new_text: String) -> void:
	sample_name_column = int(new_text)
	tab_properties[9] = int(new_text)
	_on_stat_changed()


func _on_SampleNameSheetNameEdit_text_changed(new_text):
	sample_name_sheet_name = new_text
	tab_properties[10] = new_text
	_on_stat_changed()


func _on_SampleAreaColumnEdit_text_changed(new_text: String) -> void:
	sample_area_column = int(new_text)
	tab_properties[11] = int(new_text)
	Signals.emit_signal("sample_area_column_changed", int(new_text))
	_on_stat_changed()


func _on_InternalStandardAreaColumnEdit_text_changed(new_text: String) -> void:
	internal_standard_area_column = int(new_text)
	tab_properties[12] = int(new_text)
	_on_stat_changed()


func _on_HeaderSelectionButton_item_selected(index: int) -> void:
	header = index
	tab_properties[13] = index
	_on_stat_changed()


################################################################################
## On Load/Opening Functions ##

func set_up_values() -> void:
	series_name = tab_properties[1]
	series_info = tab_properties[2]
	varying_extraction_volumes = tab_properties[3]
	extraction_volume = tab_properties[4]
	extraction_volume_column_name = tab_properties[5]
	normalization = tab_properties[6]
	masses_column_name = tab_properties[7]
	input_mode = tab_properties[8]
	sample_name_column = tab_properties[9]
	sample_name_sheet_name = tab_properties[10]
	sample_area_column = tab_properties[11]
	internal_standard_area_column = tab_properties[12]
	header = tab_properties[13]


func update_line_edits() -> void:
	series_name_edit.text = series_name
	series_info_edit.text = series_info
	extraktion_volume_selection_button._select_int(varying_extraction_volumes)
	extraction_volume_edit.text = str(extraction_volume)
	extraction_volume_column_name_edit.text = extraction_volume_column_name
	normalization_selection_button._select_int(normalization)
	normalizer_column_name_edit.text = masses_column_name
	input_mode_selection_button._select_int(input_mode)
	sample_name_column_edit.text = str(sample_name_column)
	sample_name_sheet_name_edit.text = sample_name_sheet_name
	sample_area_column_edit.text = str(sample_area_column)
	internal_standard_area_column_edit.text = str(internal_standard_area_column)
	header_selection_button._select_int(header)
	extraktion_volume_selection_button.emit_signal("item_selected", varying_extraction_volumes)
	normalization_selection_button.emit_signal("item_selected", normalization)
	input_mode_selection_button.emit_signal("item_selected", input_mode)
	Signals.emit_signal("sample_area_column_changed", sample_area_column)
	_on_stat_changed()


################################################################################
## Calculation Process Functions ##


func on_calculation_info_needed() -> void:
#	if calculation_allowed():
	var data: Array = assemble_data_for_calculation()
	Signals.emit_signal("send_general_data_for_calculation", data)
	


func assemble_data_for_calculation() -> Array:
	var data = [varying_extraction_volumes,
				extraction_volume,
				extraction_volume_column_name,
				normalization,
				masses_column_name,
				input_mode,
				sample_name_column,
				sample_name_sheet_name,
				sample_area_column,
				internal_standard_area_column,
				header]
	return data


#func calculation_allowed() -> bool:
#	var names: Array = DataManager.get_calculation_check_names()
#	var data: Array = DataManager.get_current_data_sorted_in_rows_string()
#	if varying_extraction_volumes == 0:
#		if !check_for_name(extraction_volume_column_name, names):
#			PopUpManager.show_popup(5)
#			return false
#	if normalization == 0:
#		if !check_for_name(masses_column_name, names):
#			PopUpManager.show_popup(6)
#			return false
#	if input_mode == 1:
#		if !check_for_name(sample_name_sheet_name, names):
#			PopUpManager.show_popup(7)
#			return false
#	return true
#
#
#func check_for_name(searched_name: String, all_names: Array) -> bool:
#	for n in all_names:
#		if n == searched_name:
#			return true
#	return false


################################################################################
## Summary Functions ##

func _on_stat_changed() -> void:
	var vev: String = ""
	var norm: String = ""
	var ipm: String = ""
	
	if varying_extraction_volumes == 0:
		vev = "YES"
	else:
		vev = "NO"
	if normalization == 0:
		norm = "YES"
	else:
		norm = "NO"
	if input_mode == 0:
		ipm = "Input Mode 1"
	else:
		ipm = "Input Mode 2"
	var summary_stats: Array = [
		series_name,
		vev,
		extraction_volume,
		extraction_volume_column_name,
		norm,
		masses_column_name,
		ipm,
		sample_name_column,
		sample_name_sheet_name,
		sample_area_column,
		internal_standard_area_column,
		header]
	SummaryManager.update_main_summary(summary_stats)


################################################################################
## TO ORGANIZE TAB NAMES  ##

func _on_Main_tree_exited() -> void:
	emit_signal("preset_tab_tree_exited")


################################################################################
## SETTER GETTER  ##

func set_tab_properties(new_properties: Array) -> void:
	tab_properties = new_properties
	set_up_values()
	update_line_edits()


func get_tab_properties() -> Array:
	return tab_properties




























