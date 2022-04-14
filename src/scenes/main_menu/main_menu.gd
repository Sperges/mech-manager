extends MarginContainer

export(String, FILE) var _main_scene: String
export(AudioStream) var _music

onready var _start_button: Button = $Main/Start
onready var _continue_button: Button = $Main/Continue
onready var _options_button: Button = $Main/Options
onready var _credits_button: Button = $Main/Credits
onready var _quit_button: Button = $Main/Quit

func _ready():
	# To reconfigure when the save system has been implemented
	if not File.new().file_exists("user://save.cfg"):
		_continue_button.disabled = true

	Music.stream = _music
	Music.play()


func _on_Start_pressed():
	if not _main_scene:
		printerr("No main scene selected.")
		return

	get_tree().change_scene(_main_scene)


# Only pressed when a save file is available
# To implement when save system has beem implemented
func _on_Continue_pressed():
	pass


func _on_ReallyQuit_pressed():
	get_tree().quit(0)
