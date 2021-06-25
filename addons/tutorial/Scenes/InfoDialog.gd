tool
extends Panel

signal page_changed

var page: int = 1
var total_pages: int
var content: Array
var drag_position

onready var title: String
onready var title_label = $VBoxContainer/Title
onready var rtl = $VBoxContainer/RichTextLabel
onready var note_label = $VBoxContainer/Footer/VBoxContainer/Note
onready var page_label = $VBoxContainer/Footer/VBoxContainer/Page
onready var previous_button = $VBoxContainer/Footer/VBoxContainer/HBoxContainer/Previous
onready var home_button = $VBoxContainer/Footer/VBoxContainer/HBoxContainer/HomeButton
onready var next_button = $VBoxContainer/Footer/VBoxContainer/HBoxContainer/Next


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
				rtl.bbcode_text = str("ERR_FILE_NOT_FOUND: A file called %s.json was not found in the TutorialContents (res://addons/tutorial/TutorialContents/) Folder" % title)
	f.close()
	total_pages = content.size()
#	print(title)
	rtl.bbcode_text = content[0]["content"]
	if content[page - 1].has("position"):
		rect_global_position.x = content[page - 1]["position"]["x"]
		rect_global_position.y = content[page - 1]["position"]["y"]
	previous_button.hide()
	page_label.text = "Page: %s / %s" % [page, total_pages]

func _process(delta: float) -> void:
	rect_size = $VBoxContainer.rect_size
	

func _on_InfoDialog_popup_hide() -> void:
	call_deferred("popup")


func _on_HomeButton_pressed() -> void:
	WindowManager.add_window("res://addons/tutorial/Main.tscn")
	queue_free()


func _on_Next_pressed() -> void:
	emit_signal("page_changed")
	page += 1
	if page > content.size() - 1: page = content.size() - 1


func _on_Previous_pressed() -> void:
	emit_signal("page_changed")
	page -= 1
	if page < 0: page = 0

func handle_pages():
	rtl.bbcode_text = content[page - 1]["content"]
	page_label.text = "Page: %s / %s" % [page + 1, content.size()]
	if page == 0:
		previous_button.hide()
	else:
		previous_button.show()
	
	if content[page].has("title"):
		title_label.text = title + ": " + content[page]["title"]
	
	if page == content.size():
		next_button.text = "Home"
	else:
		next_button.text = "Next >>"
	
	if content[page].has("note"):
		note_label.show()
		note_label.text = "Note: " + content[page]["note"]
	else:
		note_label.text = ""
		note_label.hide()
	
	if content[page].has("position"):
		rect_global_position.x = content[page]["position"]["x"]
		rect_global_position.y = content[page]["position"]["y"]

func _on_InfoDialog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
