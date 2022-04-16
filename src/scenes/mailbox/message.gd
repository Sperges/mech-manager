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

extends VBoxContainer

signal ok_pressed
signal dialogue_pressed(choice)

# Should be mail
export(Resource) var mail setget _set_mail

var choice: bool

onready var title: Label = $Title
onready var sender: Label = $Signature/Sender
onready var date: Label = $Signature/Date
onready var body: RichTextLabel = $ScrollContainer/VBoxContainer/Body
onready var footer: Label = $ScrollContainer/VBoxContainer/Footer
onready var tooltip: Label = $ScrollContainer/VBoxContainer/Tooltip
onready var ok_button: Button = $ScrollContainer/VBoxContainer/OK
onready var choice_buttons: HBoxContainer = $ScrollContainer/VBoxContainer/Choice

func _set_mail(new_mail: Mail) -> void:
	mail = new_mail as Mail
	render()


func render() -> void:
	yield(self, "ready")
	if not mail:
		push_error("No mail to render")
		return

	title.text = mail.title
	sender.text = mail.sender
	date.text = mail.date

	if mail.rich_text:
		body.bbcode_enabled = true
		body.bbcode_text = mail.body
	else:
		body.text = mail.body

	footer.text = mail.footer
	tooltip.text = mail.tooltip

	match mail.type:
		Mail.Type.OK:
			ok_button.show()
		Mail.Type.YES_NO:
			choice_buttons.show()


func _on_OK_pressed():
	emit_signal("ok_pressed")


func _on_Yes_pressed():
	choice = true
	emit_signal("dialogue_pressed", choice)


func _on_No_pressed():
	choice = false
	emit_signal("dialogue_pressed", choice)
