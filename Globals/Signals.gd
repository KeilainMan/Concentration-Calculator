extends Node


signal new_data_loaded(data) #Array
signal data_updated()
signal data_deleted()
signal sample_area_column_changed(column_number) #int

signal path_for_calculation_selected(path, identifier)# string, string
signal calculation_info_needed()
signal send_sample_data_for_calculation(sample_data) #Array
signal send_general_data_for_calculation(general_data) #Array
signal send_is_data_for_calculation(is_data) #Array
signal send_cc_data_for_calculation(cc_data) #Array
signal calculation_completed()

# SUMMARY SIGNALS #########################################
signal can_be_registered_for_summary(object) #tab instance
signal summary_panel_instanced(object) #summary display
