tool
extends Control


export var tween_delay: float = 0.5

var config_file: ConfigFile = ConfigFile.new()

onready var main_dialog: WindowDialog = $".."
onready var tween: Tween = $"../Tween"
onready var theme_option: OptionButton = $VBoxContainer/HBoxContainer2/OptionButton
onready var settings_panel: HBoxContainer = $"../HBoxContainer/SettingsPanel"

func _ready() -> void:
	hide()
	theme_option.selected = _load("theme", 1)
	_on_OptionButton_item_selected(theme_option.selected)


func _save(_name: String, _value):
	config_file.set_value("Settings", _name, _value)
	config_file.save("user://Settings.cfg")


func _load(_name: String, _default):
	config_file.load("user://Settings.cfg")
	return config_file.get_value("Settings", _name, _default)


func _on_Done_pressed() -> void:
	main_dialog.window_title = "Tutorials"
	settings_panel.hide_tween(self)


func _on_OptionButton_item_selected(index: int) -> void:
	var _theme
	match index:
		0:
			_theme = null
			$"../HBoxContainer/VBoxContainer3/HBoxContainer2/TextureRect".texture = load("res://addons/tutorial/Icons/Godot logo Dark Backgroud.png")
		1:
			_theme = load("res://addons/tutorial/Themes/Default.theme")
			$"../HBoxContainer/VBoxContainer3/HBoxContainer2/TextureRect".texture = load("res://addons/tutorial/Icons/Godot Logo small light.png")
		2:
			_theme = load("res://addons/tutorial/Themes/GodotDarkBlue.theme")
	main_dialog.theme = _theme
	_save("theme", index)
