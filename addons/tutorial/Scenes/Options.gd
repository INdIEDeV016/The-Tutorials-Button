tool
extends Button


signal enlarged_video

export var title: String = ""
export var stream: VideoStream
export var source_link: String

onready var title_label = $HBoxContainer/VBoxContainer/Label
onready var thumbnail = $HBoxContainer/Thumbnail
onready var link = $HBoxContainer/VBoxContainer/HBoxContainer/LinkButton



func _ready() -> void:
	title_label.text = title
	link.text = source_link
	if stream:
		thumbnail.stream = stream
		emit_signal("enlarged_video", "video_stream", stream)
		thumbnail.play()
	
	rect_size = Vector2.ZERO
	$HBoxContainer.rect_size = Vector2.ZERO
	rect_min_size = $HBoxContainer.rect_size + Vector2(0, 30)

func _on_YourFirstGame_pressed() -> void:
	pass # Replace with function body.

func _on_YourFirstGame_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if thumbnail.get_rect().has_point(get_local_mouse_position()):
			emit_signal("enlarged_video", "show")
		else:
			emit_signal("enlarged_video", "hide")

func _on_VideoPlayer_finished() -> void:
	if thumbnail is VideoPlayer: thumbnail.play()


func _on_LinkButton_pressed() -> void:
	OS.shell_open(link.text)