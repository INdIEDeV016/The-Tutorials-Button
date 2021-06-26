tool
extends Panel


var page: int = 1
var total_pages: int
var content: Array
var drag_position
var tween_delay: = 0.5

onready var title: String
onready var title_label = $VBoxContainer/Title
onready var rtl = $VBoxContainer/RichTextLabel
onready var progress_bar = $VBoxContainer/Footer/VBoxContainer/ProgressBar
onready var note_label = $VBoxContainer/Footer/VBoxContainer/Note
onready var page_label = $VBoxContainer/Footer/VBoxContainer/Page
onready var previous_button = $VBoxContainer/Footer/VBoxContainer/HBoxContainer/Previous
onready var home_button = $VBoxContainer/Footer/VBoxContainer/HBoxContainer/HomeButton
onready var next_button = $VBoxContainer/Footer/VBoxContainer/HBoxContainer/Next
onready var tween = $Tween
onready var http = $HTTPRequest


func _ready() -> void:
	set_process(false)
	theme = WindowManager.theme
	title_label.text = title
	var f: = File.new()
	var err = f.open("res://addons/tutorial/TutorialContents/%s.json" % title, File.READ)
	var parse_result: JSONParseResult
	if err == OK:
		parse_result = JSON.parse(f.get_as_text())
		content = parse_result.result
	else:
		title_label.text = "Error"
		match err:
			7:
				rtl.bbcode_text = str("ERR_FILE_NOT_FOUND: A file called %s.json was not found in the TutorialContents (res://addons/tutorial/TutorialContents/) Folder" % title)
	f.close()
	total_pages = content.size()
#	print(title)
	rtl.bbcode_text = content[page - 1]["content"].c_unescape()
	if content[page - 1].has("position"):
		rect_global_position.x = content[page - 1]["position"]["x"]
		rect_global_position.y = content[page - 1]["position"]["y"]
	previous_button.hide()
	page_label.text = "Page: %s / %s" % [page, total_pages]
#	page += 1

func _process(delta: float) -> void:
	progress_bar.value = http.get_downloaded_bytes() / http.get_body_size() * 100

func _on_InfoDialog_popup_hide() -> void:
	call_deferred("popup")


func _on_HomeButton_pressed() -> void:
	WindowManager.add_window("res://addons/tutorial/Main.tscn")
	queue_free()


func _on_Next_pressed() -> void:
	page += 1


func _on_Previous_pressed() -> void:
	page -= 1

func handle_pages():
	rect_size = $VBoxContainer.rect_size
	rtl.bbcode_text = content[page - 1]["content"]
	page_label.text = "Page: %s / %s" % [page, total_pages]
	
	if page > total_pages: page = total_pages
	
	if page < 1: page = 1
	
	if page == 1:
		previous_button.hide()
	else:
		previous_button.show()
	
	if content[page - 1].has("title"):
		title_label.text = title + ": " + content[page - 1]["title"]
	
	if page == total_pages:
		next_button.hide()
	else:
		next_button.show()
	
	if content[page - 1].has("note"):
		note_label.show()
		note_label.text = "Note: " + content[page - 1]["note"]
	else:
		note_label.text = ""
		note_label.hide()
	
	if content[page - 1].has("position"):
		rect_global_position.x = content[page - 1]["position"]["x"]
		rect_global_position.y = content[page - 1]["position"]["y"]

func _on_InfoDialog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
		$VBoxContainer/Footer/VBoxContainer/Position.text = str(rect_global_position)
		


func _on_RichTextLabel_meta_clicked(meta) -> void:
	set_process(true)
	progress_bar.show()
	if meta is String and meta.begins_with("http"):
		http.download_file = "user://assets.download"
		var err = http.request(meta)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	progress_bar.hide()
	if result == OK:
		print("http response code: %s" % response_code)
		var d = Directory.new()
		d.rename(ProjectSettings.globalize_path("user://assets.download"), ProjectSettings.globalize_path("res://addons/tutorial/dodge_assets.zip"))
		OS.shell_open(ProjectSettings.globalize_path("res://addons/tutorial/"))
	else:
		print("http result: %s" % result)
