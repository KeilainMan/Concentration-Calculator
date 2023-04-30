extends Control


onready var file_open_dialog = $FileOpenDialog
onready var main_popup_menu = $MainPopUpMenu

enum main_popup_menue_items {
	OPEN_FILE,
	LOAD_PRESET,
	SAVE_PRESET,
}

var main_popup_menue_item_label: Array = [
	"Open file",
	"Load preset",
	"Save preset",
]



var file_content: Array = []


func _ready():
	add_main_popup_menue_items()


func add_main_popup_menue_items() -> void:
	var index: int = 0
	for item in main_popup_menue_items.keys():
		main_popup_menu.add_item(main_popup_menue_item_label[index], main_popup_menue_items.get(item))
		index += 1
	
	
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




func _on_MenueButton_pressed():
	main_popup_menu.popup()


func _on_MainPopUpMenu_id_pressed(id):
	if id == main_popup_menue_items.OPEN_FILE:
		file_open_dialog.popup()
