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

extends HBoxContainer

export(ButtonGroup) var button_group: ButtonGroup

var current_button: Button = null

func _ready():
	if not button_group:
		push_error("button_group uninitialized.")
		breakpoint


func _on_Button_pressed():
	if current_button == button_group.get_pressed_button():
		button_group.get_pressed_button().pressed = false
		current_button = null
		$Windows.hide()
		return

	current_button = button_group.get_pressed_button()

	$Windows.show()

	$Windows.current_tab = current_button.get_index()
