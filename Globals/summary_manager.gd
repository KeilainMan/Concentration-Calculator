extends Node


var summary_display: ColorRect
var currently_registered_tabs: Array = []

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
	"(x,y)"
	]
var custom_cc_tab_summary_last_column: Array = ["Influences Calculation" ,"No" ,"Yes" ,"Yes" ,"Yes" ,"Yes", "Yes"]


func _ready() -> void:
	Signals.connect("can_be_registered_for_summary", self, "_on_can_be_registered_for_summary")
	Signals.connect("summary_panel_instanced", self, "_on_summary_panel_isntanced")


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

func update_is_summary(summary_stats: Array) -> void:
	custom_is_tab_summary.pop_back()
	if custom_is_tab_summary.empty():
		custom_is_tab_summary.append(custom_is_tab_summary_first_column)
	
	var tab_index: int = -1
	for col in custom_is_tab_summary:
		if col[0] == summary_stats[0]:
			tab_index = custom_is_tab_summary.find(col)
	
	if tab_index == -1:
		custom_is_tab_summary.append(summary_stats)
	else:
		custom_is_tab_summary[tab_index] = summary_stats
	
	if !custom_is_tab_summary.has(custom_is_tab_summary_last_column):
		custom_is_tab_summary.append(custom_is_tab_summary_last_column)
	
	if !summary_display == null:
		summary_display.update_is_summary(custom_is_tab_summary)

################################################################################
## Calibration Curve Summary ##

func update_cc_summary(summary_stats: Array) -> void:
	custom_cc_tab_summary.pop_back()
	if custom_cc_tab_summary.empty():
		custom_cc_tab_summary.append(custom_cc_tab_summary_first_column)
	
	var tab_index: int = -1
	for col in custom_cc_tab_summary:
		if col[0] == summary_stats[0]:
			tab_index = custom_cc_tab_summary.find(col)
	
	if tab_index == -1:
		custom_cc_tab_summary.append(summary_stats)
	else:
		custom_cc_tab_summary[tab_index] = summary_stats
	
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
	currently_registered_tabs.clear()


# Signal Callbacks #########################################

func _on_can_be_registered_for_summary(tab: Tabs) -> void:
	if !currently_registered_tabs.has(tab):
		currently_registered_tabs.append(tab)
	else: return


func _on_summary_panel_isntanced(current_summary_display: ColorRect) -> void:
	summary_display = current_summary_display

