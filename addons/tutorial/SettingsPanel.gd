tool
extends HBoxContainer


export var tween_delay: float = 0.5

onready var main_dialog = $"../.."
onready var tween = $"../../Tween"

onready var settings_scene = $"../../Settings"
onready var about_scene = $"../../About"


func _on_Settings_pressed() -> void:
	show_tween(settings_scene)
	main_dialog.window_title += ": Settings"


func _on_About_pressed() -> void:
	show_tween(about_scene)
	main_dialog.window_title += ": About"

func hide_tween(control: Control):
	tween.interpolate_property(
		control, "modulate:a",
		0.95, 0,
		tween_delay,
		Tween.TRANS_QUART, Tween.EASE_OUT
	)
	tween.start()
	yield(tween, "tween_all_completed")
	control.hide()

func show_tween(control: Control):
	control.show()
	tween.interpolate_property(
		control, "modulate:a",
		0, 0.95,
		tween_delay,
		Tween.TRANS_QUART, Tween.EASE_OUT
	)
	tween.start()
