tool
extends Panel


var page: int = 1
var sub_part: int = 0
var total_pages: int
var total_sub_part: int
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
	note_label.hide()
	progress_bar.hide()
	
	set_process(false)
	theme = WindowManager.theme
	title_label.text = title
	var f: = File.new()
	var err = f.open("res://addons/tutorial/TutorialContents/%s.json" % title, File.READ)
	var parse_result: JSONParseResult
	if err == OK:
		parse_result = JSON.parse(f.get_as_text())
		var parse_err = parse_result.error
		content = parse_result.result
		if parse_err != OK:
			title_label.text = "Error"
			rtl.bbcode_text = "Error parsing JSON at line " + str(parse_result.error_line) + ": " + parse_result.error_string
	else:
		title_label.text = "Error"
		
		match err:
			7:
				rtl.bbcode_text = str("ERR_FILE_NOT_FOUND: A file called %s.json was not found in the TutorialContents (res://addons/tutorial/TutorialContents/) Folder" % title)
	f.close()
	total_pages = content.size()
#	print(title)

	if content[page - 1].has("position"):
		rect_global_position.x = content[page - 1]["position"]["x"]
		rect_global_position.y = content[page - 1]["position"]["y"]
	rtl.bbcode_text = content[page - 1]["content"].c_unescape()
	previous_button.hide()
	page_label.text = "Page: %s / %s" % [page, total_pages]
	
	if content[page - 1].has("sub_part"): total_sub_part = content[page - 1]["sub_part"].size()
	else: total_sub_part = 1
	
	rect_min_size.x = $VBoxContainer/Footer.rect_size.x
#	page += 1

func _process(delta: float) -> void:
	progress_bar.value = http.get_downloaded_bytes() / http.get_body_size() * 100

func _on_InfoDialog_popup_hide() -> void:
	call_deferred("popup")


func _on_HomeButton_pressed() -> void:
	WindowManager.add_window("res://addons/tutorial/Main.tscn")
	queue_free()


func _on_Next_pressed() -> void:
	if sub_part != 1 and sub_part != total_sub_part: page += 1


func _on_Previous_pressed() -> void:
	if sub_part != 1 and sub_part != total_sub_part: page -= 1

func handle_pages():
	if page > total_pages: page = total_pages
	
	if page < 1: page = 1
	
	rect_size = $VBoxContainer.rect_size
	rtl.bbcode_text = content[page - 1]["content"].c_unescape()
	page_label.text = "Page: %s / %s" % [page, total_pages]
	
	if page == 1: previous_button.hide()
	else: previous_button.show()
	
	if content[page - 1].has("title"): title_label.text = title + ": " + content[page - 1]["title"]
	
	if page == total_pages: next_button.hide()
	else: next_button.show()
	
	if content[page - 1].has("note"):
		note_label.show()
		note_label.text = "Note: " + content[page - 1]["note"]
	else:
		note_label.text = ""
		note_label.hide()
	
	if content[page - 1].has("position"):
		rect_global_position.x = content[page - 1]["position"]["x"]
		rect_global_position.y = content[page - 1]["position"]["y"]
	
	if content[page - 1].has("sub_part"):
		var editor = EditorPlugin.new()
		var base_control = editor.get_editor_interface().get_base_control()
		var target_node: Control = base_control
		for node_index in content[page - 1]["sub_part"][sub_part - 1]["node_path"]:
			if node_index is float:
				target_node = target_node.get_child(node_index)
			elif node_index is String and node_index == "..":
				target_node = target_node.get_parent()
		var highlighter = load("res://addons/tutorial/Scenes/Highligter.tscn")
		highlighter = highlighter.instance() as Control
		highlighter.node = target_node
		highlighter.dialog = self
		get_viewport().call_deferred("add_child", highlighter)
	else:
		sub_part = 0

func _on_InfoDialog_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	elif event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	


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

var drag_position_resizer
var size: float
func _on_SideResizer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			drag_position_resizer = rect_size
		else:
			drag_position_resizer = null
	elif event is InputEventMouseMotion and drag_position_resizer:
		rect_size.x = get_global_mouse_position().x - drag_position_resizer.x - drag_position_resizer.x / 2
	
#	if event is InputEventMouseMotion:
#		if event.is_pressed():
#			rect_size.x = $SideResizer.rect_position.x
#		if event.position.y < rect_size.y:
#			rect_position += event.relative
