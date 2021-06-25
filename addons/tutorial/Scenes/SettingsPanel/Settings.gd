tool
extends Control


export var tween_delay: float = 0.5

var config_file: ConfigFile = ConfigFile.new()

onready var main_dialog = $".."
onready var godot_icon = $"../HBoxContainer/VBoxContainer3/HBoxContainer2/TextureRect"
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
	match index:
		0:
			WindowManager.theme = null
			godot_icon.texture = load("res://addons/tutorial/Icons/Godot logo Dark Backgroud.png")
		1:
			WindowManager.theme = load("res://addons/tutorial/Themes/Default.theme")
			godot_icon.texture = load("res://addons/tutorial/Icons/Godot Logo small light.png")
		2:
			WindowManager.theme = load("res://addons/tutorial/Themes/GodotDarkBlue.theme")
			godot_icon.texture = load("res://addons/tutorial/Icons/Godot logo Dark Backgroud.png")
		3:
			WindowManager.theme = load("res://addons/tutorial/Themes/Light.theme")
			godot_icon.texture = load("res://addons/tutorial/Icons/Godot Logo small light.png")
	main_dialog.theme = WindowManager.theme
	_save("theme", index)
