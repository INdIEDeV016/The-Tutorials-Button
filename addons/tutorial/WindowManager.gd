tool
extends Node

var theme: Theme
var editor: = EditorPlugin.new()

func add_window(window_path: String, window_title: String = "Tutorials"):
	var window: Control = load(window_path).instance()
#	prints(window, theme)
	var base_control: = editor.get_editor_interface().get_base_control()
	
	if window is WindowDialog:
		window.call_deferred("popup")
		window.window_title = window_title
	elif window is Panel:
		window.title = window_title
	window.theme = theme
	base_control.add_child(window)
