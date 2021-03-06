# Copyright 2022 friedliverclub@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

extends MarginContainer

export(String, FILE) var _main_scene: String = "res://icon.png"
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
		printerr(filename, ": Error, _main_scene uninitalized, no scene to change to.")
		return

	var err = get_tree().change_scene(_main_scene)

	match err:
		ERR_CANT_OPEN:
			printerr(filename, ": Error, can't open file ", _main_scene)
		ERR_CANT_CREATE:
			printerr(filename, ": Error, can't instantiate scene ", _main_scene)


# Only pressed when a save file is available
# To implement when save system has beem implemented
func _on_Continue_pressed():
	pass


func _on_ReallyQuit_pressed():
	get_tree().quit(0)
