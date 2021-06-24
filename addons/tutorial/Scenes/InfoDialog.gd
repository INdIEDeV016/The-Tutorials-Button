tool
extends WindowDialog


func _on_InfoDialog_popup_hide() -> void:
	queue_free()
