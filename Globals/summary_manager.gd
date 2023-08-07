extends Node


var summary_display: ColorRect
var currently_registered_is_tabs: Array = []
var currently_registered_cc_tabs: Array = []

var main_summary: Array = []
var main_summary_first_column: Array = [
	"Properties",
	"Series Name",
	"Varying Extraction Volumes",
	"Extraction Volume in ml",
	"Extraction Volume Column Name",
	"Normalization (by mass in mg)",
	"Masses Column Name",
	"Input Mode",
	"Sample Names Sheet Name",
	"Sample Names Column",
	"Sample Area Column",
	"Internal Standard Area Column",
	"Header",
]

var custom_is_tab_summary: Array = []
var custom_is_tab_summary_first_column: Array = [
	"Tab Name",
	"Compound Name",
	"Internal Standard",
	"IS Concentration",
	"Response Factor",
	"Column Name",
	
]
var custom_is_tab_summary_last_column: Array = ["Influences Calculation" ,"No" ,"No" ,"Yes" ,"Yes" ,"Yes"]

var custom_cc_tab_summary: Array = []
var custom_cc_tab_summary_first_column: Array = [
	"Tab_name",
	"Compound Name",
	"Column Name",
	"Curve Slope",
	"Curve Intercept",
	"R^2 Value",
	"x | y"
	]
var custom_cc_tab_summary_last_column: Array = ["Influences Calculation" ,"No" ,"Yes" ,"Yes" ,"Yes" ,"Yes", "Yes"]

var export_summary: Array = [] setget , get_export_summary


func _ready() -> void:
	Signals.connect("can_be_registered_for_summary", self, "_on_can_be_registered_for_summary")
	Signals.connect("summary_panel_instanced", self, "_on_summary_panel_isntanced")
	Signals.connect("calculation_completed", self, "_on_calculation_completed")


################################################################################
## Main Summary ##

func update_main_summary(main_summary_data: Array) -> void:
	main_summary.clear()
	main_summary.append(main_summary_first_column)
	main_summary.append(main_summary_data)
	var third_column: Array = construct_third_main_column(main_summary_data)
	main_summary.append(third_column)
	main_summary[1].insert(0, "Values")
	main_summary[2].insert(0, "Influences Calculation")

	if !summary_display == null:
		summary_display.update_main_summary(main_summary)


func construct_third_main_column(main_summary_data: Array) -> Array:
	var column: Array = []
	for index in main_summary_data.size():
		column.append("Yes")
		
	if main_summary_data[1] == "YES":
		column[2] = "No"
	else:
		column[3] = "No"
		
	if !main_summary_data[4] == "YES":
		column[5] = "No"
	
	if main_summary_data[6] == "Input Mode 1":
		column[7] = "No"
		column[9] = "No"
		column[10] = "No"
		column[11] = "Is included"

	return column

################################################################################
## Internal Standard Summary ##

func update_is_summary(summary_stats: Array, tab: InternalStandardTab) -> void:
	custom_is_tab_summary.pop_back()
	if custom_is_tab_summary.empty():
		custom_is_tab_summary.append(custom_is_tab_summary_first_column)
	
	
	var tab_index: int = currently_registered_is_tabs.find(tab)
	if tab_index == -1:
		return
	if custom_is_tab_summary.size() - 1 > tab_index:
		custom_is_tab_summary[tab_index + 1] = summary_stats
	else:
		custom_is_tab_summary.append(summary_stats)
#	var tab_index: int = -1
#	for col in custom_is_tab_summary:
#		if col[0] == summary_stats[0]:
#			tab_index = custom_is_tab_summary.find(col)
#
#	if tab_index == -1:
#		custom_is_tab_summary.append(summary_stats)
#	else:
#		custom_is_tab_summary[tab_index] = summary_stats
	
	if !custom_is_tab_summary.has(custom_is_tab_summary_last_column):
		custom_is_tab_summary.append(custom_is_tab_summary_last_column)
	
	if !summary_display == null:
		summary_display.update_is_summary(custom_is_tab_summary)

################################################################################
## Calibration Curve Summary ##

func update_cc_summary(summary_stats: Array, tab: CalibrationCurveTab) -> void:
	custom_cc_tab_summary.pop_back()
	if custom_cc_tab_summary.empty():
		custom_cc_tab_summary.append(custom_cc_tab_summary_first_column)
	
	var tab_index: int = currently_registered_cc_tabs.find(tab)
	if tab_index == -1:
		return
	if custom_cc_tab_summary.size() - 1 > tab_index:
		custom_cc_tab_summary[tab_index + 1] = summary_stats
	else:
		custom_cc_tab_summary.append(summary_stats)
	
	if !custom_cc_tab_summary.has(custom_cc_tab_summary_last_column):
		custom_cc_tab_summary.append(custom_cc_tab_summary_last_column)
	
	if !summary_display == null:
		summary_display.update_cc_summary(custom_cc_tab_summary)


################################################################################
## Full Summary Functions ##

func clear_summary() -> void:
	main_summary.clear()
	custom_cc_tab_summary.clear()
	custom_is_tab_summary.clear()
	if !summary_display == null:
		summary_display.update_all_summarys()


func clear_registered_tabs() -> void:
	currently_registered_is_tabs.clear()
	currently_registered_cc_tabs.clear()


func clear_export_summary() -> void:
	export_summary.clear()


################################################################################
## On Export Functions ##

func build_export_summary() -> void:
	if !main_summary.empty():
		var main_summary_transposed: Array = transpose_array(main_summary)
		export_summary.append_array(main_summary_transposed)
		export_summary.append([""])
		
	if !custom_is_tab_summary.empty():
		var is_summary_transposed: Array = transpose_array(custom_is_tab_summary)
		export_summary.append(["Internal Standard Tabs"])
		export_summary.append_array(is_summary_transposed)
		export_summary.append([""])
		
	if !custom_cc_tab_summary.empty():
		var cc_summary_transposed: Array = transpose_array(custom_cc_tab_summary)
		export_summary.append(["Calibration Curve Tabs"])
		export_summary.append_array(cc_summary_transposed)


func transpose_array(summary: Array) -> Array:
	var max_row_count: int = find_max_row_count(summary)
	var summary_transposed: Array = []
	var adjusted_summary: Array = summary
	
	for n in max_row_count:
		summary_transposed.append([])
	
	for col in adjusted_summary: #addiert "" damit man auf gleichartige Arrays entstehen
		if col.size() < max_row_count:
			var diff: int = max_row_count - col.size()
			for n in diff:
				col.append("")
	
	for col in adjusted_summary:
		for entry_index in col.size():
			summary_transposed[entry_index].append(String(col[entry_index]))
	
	return summary_transposed


func find_max_row_count(summary: Array) -> int:
	var max_row_count: int = 0
	for col in summary:
		if col.size() > max_row_count:
			max_row_count = col.size()
	
	return max_row_count


################################################################################
## Signal Callbacks ##

func _on_can_be_registered_for_summary(tab: Tabs) -> void:
	if tab is CalibrationCurveTab:
		if !currently_registered_cc_tabs.has(tab):
			currently_registered_cc_tabs.append(tab)
	elif tab is InternalStandardTab:
		if !currently_registered_is_tabs.has(tab):
			currently_registered_is_tabs.append(tab)
	else: return


func _on_summary_panel_isntanced(current_summary_display: ColorRect) -> void:
	summary_display = current_summary_display
	

func _on_calculation_completed() -> void:
	clear_export_summary()



################################################################################
## Setter Getter ##

func get_export_summary() -> Array:
	build_export_summary()
	return export_summary
