extends Control

onready var spreadsheet_tab: PackedScene = preload("res://SpreadsheetBase/SpreadsheetTab.tscn")


func _ready():
	Signals.connect("new_data_loaded", self, "_on_new_data_loaded")


func _on_new_data_loaded(data: Array, sheet_names: Array) -> void:
	delete_old_spreadsheet()
	
	for sheet_index in data.size():
		var new_tab: Tabs = spreadsheet_tab.instance()
		add_child(new_tab)
		new_tab.set_data(data[sheet_index])
		if sheet_index < sheet_names.size():
			new_tab.name = sheet_names[sheet_index]


func delete_old_spreadsheet() -> void:
	for child in get_children():
		child.queue_free()
