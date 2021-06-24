tool
extends Node

var theme: Theme
var editor = EditorPlugin.new()

func add_window(window_path: String, theme_file_path: String = ""):
	var window = load(window_path).instance()
	
	if not theme_file_path.empty():
		theme = load(theme_file_path)
	else:
		theme = null
	print(theme)
	var editor_interface = editor.get_editor_interface()
	var base_control = editor_interface.get_base_control()
	base_control.add_child(window)
	window.call_deferred("popup")
	window.theme = theme
