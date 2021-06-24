tool
extends EditorPlugin

var button

func _enter_tree() -> void:
	button = load("res://addons/tutorial/Scenes/TutorialButton.tscn")
	button = button.instance() as Button
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.get_parent().move_child(button, 4)
	
	add_autoload_singleton("WindowManager", "res://addons/tutorial/WindowManager.gd")


func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.queue_free()
