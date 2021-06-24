tool
extends Node


var editor = EditorPlugin.new()



func add_window(window):
	var editor_interface = editor.get_editor_interface()
	var base_control = editor_interface.get_base_control()
	base_control.add_child(window)
