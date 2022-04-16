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

tool
class_name VTabContainer, "res://assets/icons/vtab_container.svg"
extends HBoxContainer

signal contents_modified
signal contents_removed

export(bool) var buttons_expand := false setget _on_Buttons_Expand_enabled

var button_group := ButtonGroup.new()
var current_button: Button = null
# Set in _assign_containers
var button_container: VBoxContainer
var content_container: TabContainer

func _ready():
	for sig in ["node_added", "node_renamed", "node_removed"]:
		var err = get_tree().connect(sig , self, "_on_Contents_modified")
		if err != OK:
			push_error("Signal " + sig + " already connected.")

	var err = get_tree().connect("node_removed", self, "_on_Contents_removed")
	if err != OK:
		push_error("Signal already connected.")

	_assign_containers()
	update_configuration_warning()

	_configure_content_container()
	_refresh_buttons()

	content_container.hide()


func _configure_content_container() -> void:
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.tabs_visible = false


func _refresh_buttons() -> void:
	for button in button_container.get_children():
		button_container.remove_child(button)
		button.queue_free()

	for content in content_container.get_children():
		_add_button(content.get_index(), content.name)


func _add_button(idx: int, button_text: String) -> void:
	var new_button = Button.new()

	new_button.toggle_mode = true
	new_button.group = button_group
	new_button.text = button_text
	new_button.connect("pressed", self, "_on_Button_pressed")

	if buttons_expand:
		new_button.size_flags_vertical = Control.SIZE_EXPAND_FILL

	button_container.add_child(new_button)
	button_container.move_child(new_button, idx)


func _on_Contents_modified(node: Node) -> void:
	if is_a_parent_of(node):
		_assign_containers()
		update_configuration_warning()

	if not content_container.is_a_parent_of(node):
		return

	call_deferred("_refresh_buttons")
	emit_signal("contents_modified")

func _on_Contents_removed(node: Node) -> void:
	if not content_container.is_a_parent_of(node):
		return

	content_container.hide()
	emit_signal("contents_removed")


## Functions like normal tabs, but is able to select none.
func _on_Button_pressed():
	if current_button == button_group.get_pressed_button():
		button_group.get_pressed_button().pressed = false
		current_button = null
		content_container.hide()
		return

	current_button = button_group.get_pressed_button()

	content_container.show()

	content_container.current_tab = current_button.get_index()


func _assign_containers() -> void:
	var vbox_count := 0
	var tab_count := 0

	for child in get_children():
		if child is VBoxContainer:
			vbox_count += 1
			button_container = child
			continue
		if child is TabContainer:
			tab_count += 1
			content_container = child
			continue

	if not vbox_count == 1 or not tab_count == 1:
		button_container = null
		content_container = null

	if not content_container.is_connected("visibility_changed", self,
			"on_TabContainer_visibility_changed"):
		var err = content_container.connect("visibility_changed", self,
				"on_TabContainer_visibility_changed")
		if err != OK:
			push_error("Signal already connected.")


func _get_configuration_warning():
	if not button_container or not content_container:
		return "VTabContainer must be the direct parent of exactly 1 "\
				+ "VBoxContainer and 1 TabContainer."
	if content_container.visible:
		return "TabContainer will hide by default. Making it visible "\
				+ "for editing is fine, but it will hide upon "\
				+ "running."
	return ""


func _on_Buttons_Expand_enabled(expand: bool) -> void:
	buttons_expand = expand
	_refresh_buttons()

func on_TabContainer_visibility_changed() -> void:
	update_configuration_warning()
