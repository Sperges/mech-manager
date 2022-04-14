extends VBoxContainer

enum {MASTER_BUS, MUSIC_BUS, SOUND_BUS}

onready var _master_slider: HSlider = $MasterBus/HSlider
onready var _sound_slider: HSlider = $SoundBus/HSlider
onready var _music_slider: HSlider = $MusicBus/HSlider

onready var _fullscreen_button: CheckButton = $Fullscreen
onready var _vsync_button: CheckButton = $Vsync

func _ready():
	_update_ui_elements()
	get_tree().connect("screen_resized", self, "_update_buttons")


func _on_Fullscreen_toggled(button_pressed: bool):
	OS.set_window_fullscreen(button_pressed)


func _on_Vsync_toggled(button_pressed: bool):
	OS.set_use_vsync(button_pressed)


func _on_Master_value_changed(value: float):
	AudioServer.set_bus_volume_db(MASTER_BUS, linear2db(value))


func _on_Music_value_changed(value: float):
	AudioServer.set_bus_volume_db(MUSIC_BUS, linear2db(value))


func _on_Sound_value_changed(value: float):
	AudioServer.set_bus_volume_db(SOUND_BUS, linear2db(value))


func _update_ui_elements() -> void:
	_fullscreen_button.pressed = OS.is_window_fullscreen()
	_vsync_button.pressed = OS.is_vsync_enabled()
	_master_slider.value = db2linear(AudioServer.get_bus_volume_db(MASTER_BUS))
	_music_slider.value = db2linear(AudioServer.get_bus_volume_db(MUSIC_BUS))
	_sound_slider.value = db2linear(AudioServer.get_bus_volume_db(SOUND_BUS))
