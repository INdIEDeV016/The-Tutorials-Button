tool
extends ToolButton


func _on_TutorialButton_pressed() -> void:
	WindowManager.add_window("res://addons/tutorial/Main.tscn")
	WindowManager.tutorial_button = self
	disabled = true
