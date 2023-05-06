extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func calc_compound_concentrations(data: Array, mass_column: Array, extraction_volume: float) -> void:
	var prepared_data: Array = prepare_data(data)
	
	for entry in prepared_data[0].size():
		var result_in_ng_mg: float = calc_result(prepared_data[0][entry],\
		prepared_data[1][entry], \
		mass_column[entry], \
		extraction_volume)


func prepare_data(data: Array) -> Array:
	var data_without_rownames: Array = remove_rownames_from_data(data)
	
	return data_without_rownames


func remove_rownames_from_data(data: Array) -> Array:
	var col1: Array = data[0]
	col1.pop_front()
	var col2: Array = data[1]
	col2.pop_front()
	
	return [col1, col2]


func calc_result(sample_area , is_area, mass, extraction_volume) -> float:
	var result: float = (sample_area/is_area) * 
