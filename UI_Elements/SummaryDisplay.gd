extends ColorRect


onready var main_summary_column_container: HBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer/MainSummaryContainer/MainSummaryColumnContainer
onready var is_summary_column_container: HBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer/ISSummaryContainer/ISSummaryColumnContainer
onready var cc_summary_column_container: HBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer/CCSummaryContainer/CCSummaryColumnContainer


var main_summary: Array = []




func _ready() -> void:
	Signals.emit_signal("summary_panel_instanced", self)


################################################################################
## Main Summary ##

func update_main_summary(data: Array) -> void:
	print("MAIN SUMMARY UPDATE")
	for child in main_summary_column_container.get_children():
		child.queue_free()
	var all_labels: Array = [[],[],[]]
	
	for column_index in data.size():
		var col_container: VBoxContainer = VBoxContainer.new()
		for entry in data[column_index]:
			var new_label = Label.new()
			new_label.text = String(entry)
			col_container.add_child(new_label)
			all_labels[column_index].append(new_label)
		main_summary_column_container.add_child(col_container)
	format_main_summary_labels(all_labels)


func format_main_summary_labels(all_labels: Array) -> void:
	for column_index in all_labels.size():
		for label in all_labels[column_index]:
			label.rect_min_size = Vector2(100,20)
			if column_index == 0:
				label.align = 0
				label.valign = 1
			else:
				label.align = 1


################################################################################
## Internal Standard Summary ##

func update_is_summary(data: Array) -> void:
	for child in is_summary_column_container.get_children():
		child.queue_free()
		
	var all_labels: Array = []
	for n in data.size():
		all_labels.append([])
	
	for column_index in data.size():
		var col_container: VBoxContainer = VBoxContainer.new()
		for entry in data[column_index]:
			var new_label = Label.new()
			new_label.text = String(entry)
			col_container.add_child(new_label)
			all_labels[column_index].append(new_label)
		is_summary_column_container.add_child(col_container)
	format_main_summary_labels(all_labels)


################################################################################
## Calibration Curve Summary ##

func update_cc_summary(data: Array) -> void:
	for child in cc_summary_column_container.get_children():
		child.queue_free()
		
	var all_labels: Array = []
	for n in data.size():
		all_labels.append([])
	
	for column_index in data.size():
		var col_container: VBoxContainer = VBoxContainer.new()
		for entry_index in data[column_index].size():
			var entry = data[column_index][entry_index]
#			if (entry_index == 3 or entry_index == 4) and !column_index == 0 and !column_index == data.size() - 1:
#				for x in data[column_index][entry_index]:
#					entry = x
#					var new_label = Label.new()
#					new_label.text = String(entry)
#					col_container.add_child(new_label)
#					all_labels[column_index].append(new_label)
#			else:
			var new_label = Label.new()
			new_label.text = String(entry)
			col_container.add_child(new_label)
			all_labels[column_index].append(new_label)
		cc_summary_column_container.add_child(col_container)
	format_main_summary_labels(all_labels)


func update_all_summarys() -> void:
	update_main_summary([])
	update_is_summary([])
	update_cc_summary([])

