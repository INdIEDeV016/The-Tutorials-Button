tool
extends Control

var node: Control

func _ready() -> void:
	node.connect("gui_input", self, "_on_parent_gui_input")
	rect_global_position = node.rect_global_position
	rect_size = node.rect_size

func _on_parent_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		queue_free()
