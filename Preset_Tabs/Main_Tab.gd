extends Tabs
class_name Main_Tab

onready var series_name_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/SeriesNameContainer/SeriesNameEdit
onready var compound_class_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/CompoundClassContainer/CompoundClassEdit
onready var extraction_volume_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/ExtractionVolumeContainer/ExtractionVolumeEdit
onready var masses_column_edit = $Spacer/HBoxContainer/LeftSpace/VBoxContainer/MassesColumnContainer/MassesColumnEdit



var tab_resource: Resource setget set_tab_resource

var series_name: String = ""
var compound_class: String = ""
var extraction_volume: float = 0.0
var masses_column_name: String = ""


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SeriesNameEdit_text_changed(new_text):
	series_name = new_text
	save_to_resource()


func _on_CompoundClassEdit_text_changed(new_text):
	compound_class = new_text
	save_to_resource()


func _on_ExtractionVolumeEdit_text_changed(new_text):
	extraction_volume = float(new_text)
	save_to_resource()


func _on_MassesColumnEdit_text_changed(new_text):
	masses_column_name = new_text
	save_to_resource()


func set_up_values() -> void:
	series_name = tab_resource.series_name
	compound_class = tab_resource.compound_class
	extraction_volume = tab_resource.extraction_volume
	masses_column_name = tab_resource.masses_column_name


func update_line_edits() -> void:
	series_name_edit.text = series_name
	compound_class_edit.text = compound_class
	extraction_volume_edit.text = str(extraction_volume)
	masses_column_edit.text = masses_column_name


func save_to_resource() -> void:
	tab_resource.series_name = series_name
	tab_resource.compound_class = compound_class
	tab_resource.extraction_volume = extraction_volume
	tab_resource.masses_column_name = masses_column_name




###########################

func set_tab_resource(new_resource: Resource) -> void:
	tab_resource = new_resource
	set_up_values()
	update_line_edits()

