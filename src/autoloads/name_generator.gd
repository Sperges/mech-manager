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

extends Node

enum {FEMALE, MALE}

const SEX_NAME := {true: "male", false: "female"}

var name_list: String = "res://wordlist"
var wordlist := ConfigFile.new()

func _ready():
	randomize()
	var err: int = wordlist.load(name_list)
	if err != OK:
		push_error("Could not load " + name_list + ". Error " + str(err))

	var ids := []
	for _i in range(20):
		ids.append(get_id())

	for id in ids:
		print(id["prefix"], " ", id["name"], ". ", id["sex"].capitalize(), ". Nicknamed '", id["nickname"], "'")

func get_id() -> Dictionary:
	var sex: bool = _get_sex()

	return {
		"sex": SEX_NAME[sex],
		"prefix": _get_prefix(sex),
		"name": _get_name(sex),
		"nickname": _get_nickname(),
		"suffix": _get_suffix()
	}


func _get_sex() -> bool:
	if randf() > 0.5:
		return true
	return false


func _get_prefix(male := true) -> String:
	var type: String
	if randf() > 0.25:
		if male:
			type = "common_male_prefixes"
		else:
			type = "common_female_prefixes"
	else:
		if male:
			type = "uncommon_male_prefixes"
		else:
			type = "uncommon_female_prefixes"

	var prefixes: Array
	prefixes = wordlist.get_value("people", type)

	return prefixes[randi() % prefixes.size()]


func _get_name(male := true) -> String:
	var type: String
	if male:
		type = "first_male_names"
	else:
		type = "first_female_names"

	var first_names: Array
	var last_names: Array
	first_names = wordlist.get_value("people", type)
	last_names = wordlist.get_value("people", "last_names")

	return first_names[randi() % first_names.size()] + " "\
			+ last_names[randi() % last_names.size()]


func _get_nickname():
	var nickname: String = ""
	var nouns = wordlist.get_value("people", "nickname_nouns")
	var adjectives = wordlist.get_value("people", "nickname_adjectives")

	if randf() < 0.33:
		nickname += "The "

	var type: String
	if randf() < 0.5:
		type = "adj"
	else:
		type = "noun"

	if type == "noun":
		nickname += _random_element(nouns)
		if randf() > 0.3:
			nickname += " " + _random_element(nouns)

	if type == "adj":
		nickname += _random_element(adjectives)
		if randf() > 0.3:
			nickname += " " + _random_element(nouns)

	return nickname


func _get_suffix() -> String:
	if randf() > 0.33:
		return ""

	var type: String
	if randf() > 0.5:
		type = "suffixes"
	else:
		type = "numeral_suffixes"

	var suffixes: Array = wordlist.get_value("people", type)

	return suffixes[randi() % suffixes.size()]


func _random_element(array: Array):
	return array[randi() % array.size()]
