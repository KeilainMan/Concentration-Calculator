extends Control


var file_content: Array = []


func _ready():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path) -> void:
	#print(path)
	var file: File = File.new()
	file.open(path, File.READ)
	
	while file.get_position() < file.get_len():
		var content = file.get_csv_line("	")
		file_content.append(content)
#	var split_content = content.split("	")
	#print(file_content)
	Signals.emit_signal("data_received", file_content)
