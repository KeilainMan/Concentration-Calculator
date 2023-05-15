extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func perform_linear_regression(x_data: Array, y_data: Array, intercept_flag: int) -> Array:
	if !x_data.size() == y_data.size():
		print("Unequal x and y datapoints!")
	
	var regression_params: Array = []
	
	if intercept_flag == 0:
		regression_params.append_array(linear_regression_without_intercept(x_data, y_data))
	else:
		regression_params.append_array(linear_regression_with_intercept(x_data, y_data))
	
	print("Slope: " , stepify(regression_params[0], 0.0000000001))
	print("YIntercept: ", stepify(regression_params[1], 0.0000000001))
	print("R-Squared: ", stepify(regression_params[2], 0.0000000001))
	
	return regression_params


func linear_regression_without_intercept(x_data: Array, y_data: Array) -> Array:
	var sum_of_x_sq: float = 0.0
	var sum_of_y_sq: float = 0.0
	var sum_codeviates: float = 0.0
	var sum_codeviates_sq: float = 0.0

	for n in x_data.size():
		var x = x_data[n]
		var y = y_data[n]
		print(typeof(x), " ", typeof(y))
		sum_of_x_sq += x * x
		sum_of_y_sq += y * y
		sum_codeviates += x * y
		sum_codeviates_sq += (x * y) * (x * y)#pow(x * y, 2)
		
	var r_Squared: float = sum_codeviates_sq / (sum_of_x_sq * sum_of_y_sq)
	var y_Intercept: float = 0.0
	var slope: float = (sum_codeviates / sum_of_x_sq) * 100000
	
	return [slope, y_Intercept, r_Squared]
		
		
		
		
		

func linear_regression_with_intercept(x_data: Array, y_data: Array) -> Array:
	var sum_of_x: float = 0.0
	var sum_of_y: float = 0.0
	var sum_of_x_sq: float = 0.0
	var sum_of_y_sq: float = 0.0
	var sum_codeviates: float = 0.0
	
	for n in x_data.size():
		var x = x_data[n]
		var y = y_data[n]
		
		sum_of_x += x
		sum_of_y += y
		sum_of_x_sq += x * x
		sum_of_y_sq += y * y
		sum_codeviates += x * y
		
	var count: int = x_data.size()
	var ss_x = sum_of_x_sq - ((sum_of_x * sum_of_x) / count)
	
	var r_numerator: float = (count * sum_codeviates) - (sum_of_x * sum_of_y)
	var r_denom: float = (count * sum_of_x_sq - (sum_of_x * sum_of_x)) * (count * sum_of_y_sq - (sum_of_y * sum_of_y))
	var s_Co: float = sum_codeviates - ((sum_of_x * sum_of_y) / count)
	var mean_x: float = sum_of_x / count
	var mean_y: float = sum_of_y / count
	var dbl_r: float = r_numerator / sqrt(r_denom)
	
	var r_Squared: float = dbl_r * dbl_r
	var y_Intercept: float = mean_y - ((s_Co / ss_x) * mean_x)
	var slope: float = s_Co / ss_x
	
	return [slope, y_Intercept, r_Squared]
