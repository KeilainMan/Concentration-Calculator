extends Control

onready var spreadsheet_tab: PackedScene = preload("res://SpreadsheetBase/SpreadsheetTab.tscn")

var current_sheet_count: int = 0
var destruction_sheet_count: int = 0

var temp_data: Array = []
var temp_sheet_names: Array = []

func _ready():
	Signals.connect("new_data_loaded", self, "_on_new_data_loaded")
	Signals.connect("data_deleted", self, "delete_old_spreadsheet")


func _on_new_data_loaded(data: Array, sheet_names: Array) -> void:
	temp_data = data
	temp_sheet_names = sheet_names
	delete_old_spreadsheet()


func delete_old_spreadsheet() -> void:
	if get_child_count() == 0:
		instance_new_sheets()
		return
	for child in get_children():
		child.queue_free()


func _on_sheet_exited_tree() -> void:
	destruction_sheet_count +=1
	if destruction_sheet_count == current_sheet_count:
		current_sheet_count = 0
		instance_new_sheets()
		destruction_sheet_count = 0


func instance_new_sheets() -> void:
	for sheet_index in temp_data.size():
		var new_tab: Tabs = spreadsheet_tab.instance()
		add_child(new_tab)
		current_sheet_count += 1
		new_tab.set_data(temp_data[sheet_index])
		if sheet_index < temp_sheet_names.size():
			new_tab.name = temp_sheet_names[sheet_index]
	
	temp_data.clear()
	temp_sheet_names.clear()
