tool
extends Panel

signal page_changed

var page: int = 0
var total_pages: int
var content: Array
var drag_position

onready var title: String
onready var title_label = $Title
onready var rtl = $RichTextLabel
onready var page_label = $Footer/Page
onready var previous_button = $Footer/HBoxContainer/Previous
onready var home_button = $Footer/HBoxContainer/HomeButton
onready var next_button = $Footer/HBoxContainer/Next


func _ready() -> void:
	connect("page_changed", self, "handle_pages")
	
	theme = WindowManager.theme
	title_label.text = title
	var f: = File.new()
	var err = f.open("res://addons/tutorial/TutorialContents/%s.json" % title, File.READ)
	if err == OK:
		content = parse_json(f.get_as_text())
	else:
		title_label.text = "Error"
		match err:
			7:
				rtl.text = str("ERR_FILE_NOT_FOUND: A file called %s.json was not found in the TutorialContents (res://addons/tutorial/TutorialContents/) Folder" % title)
	f.close()
#	print(title)
	rtl.text = content[0]["content"]
	if content[0].has("position"):
		rect_global_position.x = content[0]["position"]["x"]
		rect_global_position.y = content[0]["position"]["y"]
	previous_button.hide()
	page_label.text = "Page: %s / %s" % [page, content.size()]


func _on_InfoDialog_popup_hide() -> void:
	call_deferred("popup")


func _on_HomeButton_pressed() -> void:
	WindowManager.add_window("res://addons/tutorial/Main.tscn")
	queue_free()


func _on_Next_pressed() -> void:
	emit_signal("page_changed")
	if page < content.size() - 1: page += 1
	else: page = content.size()
	
	rtl.text = content[page]["content"]
	if content[page].has("title"):
		title_label.text = title + ": " + content[page]["title"]
	else:
		title_label.text = title
	if content[page].has("position"):
		rect_global_position.x = content[page]["position"]["x"]
		rect_global_position.y = content[page]["position"]["y"]


func _on_Previous_pressed() -> void:
	emit_signal("page_changed")
	if page > 0: page -= 1
	else: page = 0
	
	rtl.text = content[page]["content"]
	if content[page].has("title"):
		title_label.text = title + ": " + content[page]["title"]
	else:
		title_label.text = title
	if content[page].has("position"):
		rect_global_position.x = content[page]["position"]["x"]
		rect_global_position.y = content[page]["position"]["y"]

func handle_pages():
	page_label.text = "Page: %s / %s" % [page, content.size()]
	if page == 0:
		previous_button.hide()
	else:
		previous_button.show()
	
	if page == content.size():
		next_button.text = "Home"
	else:
		next_button.text = "Next >>"

func _on_InfoDialog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
