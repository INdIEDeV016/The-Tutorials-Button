tool
extends WindowDialog 

export var tween_delay: float = 0.5

onready var enlarged_video_stream

onready var settings_panel = $HBoxContainer/SettingsPanel
onready var godot_icon = $HBoxContainer/VBoxContainer3/HBoxContainer2/TextureRect
onready var enlarged_video = $Enlarged
onready var tween = $Tween

var settings_open: bool = false

func _ready() -> void:
	call_deferred("popup")
#	rect_size = Vector2(1221, 756)
	window_title = "Tutorials"
	settings_panel.rect_min_size.x = 0
	settings_panel.get_node("Panel/VBoxContainer").hide()
	
	enlarged_video.connect("finished", self, "on_Enlarged_finished")
	for option in $HBoxContainer/VBoxContainer3/ScrollContainer/VBoxContainer.get_children():
		option.connect("enlarged_video", self, "set_enlarged_video")
	
	enlarged_video.stream = enlarged_video_stream
	enlarged_video.play()
	enlarged_video.show()


func _on_WindowDialog_popup_hide() -> void:
	queue_free()


func _on_Puller_pressed() -> void:
	if not settings_open:
		open_side_panel()
		settings_open = true
	else:
		close_side_panel()
		settings_open = false


func open_side_panel():
	tween.interpolate_property(
		settings_panel.get_node("Panel"), "rect_scale",
		Vector2.DOWN, Vector2.ONE,
		tween_delay / 2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	)
	settings_panel.get_node("Panel/VBoxContainer").show()
	tween.interpolate_property(
		settings_panel, "rect_min_size:x",
		0, 100,
		tween_delay,
		Tween.TRANS_QUART, Tween.EASE_OUT
	)
	tween.start()
	settings_panel.get_node("Puller").text = "<"

func close_side_panel():
#	tween.interpolate_property(
#		settings_panel.get_node("Panel"), "rect_scale",
#		Vector2.ONE, Vector2.DOWN,
#		tween_delay / 2,
#		Tween.TRANS_QUART, Tween.EASE_OUT
#	)
	settings_panel.get_node("Panel/VBoxContainer").hide()
	tween.interpolate_property(
		settings_panel, "rect_min_size:x",
		100, 0,
		tween_delay,
		Tween.TRANS_QUART, Tween.EASE_OUT
	)
	tween.start()
	settings_panel.get_node("Puller").text = ">"


func set_enlarged_video(what: String, value = null) -> void:
#	prints(what, value)
	match what:
		"show":
			enlarged_video.show()
			enlarged_video.rect_position = get_global_mouse_position()# + Vector2(large_video.rect_size.x / 7, large_video.rect_size.y / 2)
		"hide":
			enlarged_video.hide()
		"stream":
			enlarged_video.stream = value

func _on_Enlarged_finished() -> void:
	enlarged_video.play()


func _on_TextureRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			OS.shell_open("https://www.godotengine.org")


