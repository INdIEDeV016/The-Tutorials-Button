tool
extends Control


onready var main_dialog = $"../"
onready var settings_panel: HBoxContainer = $"../HBoxContainer/SettingsPanel"

func _ready() -> void:
	hide()


func _on_OK_pressed() -> void:
	main_dialog.window_title = "Tutorials"
	settings_panel.hide_tween(self)


func _on_RichTextLabel_meta_clicked(meta: String) -> void:
	OS.shell_open(meta)
