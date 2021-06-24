tool
extends ToolButton

var main_window = preload("res://addons/tutorial/Main.tscn")


func _on_TutorialButton_pressed() -> void:
	var window = main_window.instance()
	WindowManager.add_window(window)
