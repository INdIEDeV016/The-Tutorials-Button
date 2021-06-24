tool
extends WindowDialog

func _ready() -> void:
	theme = WindowManager.theme

func _on_InfoDialog_popup_hide() -> void:
	show()
