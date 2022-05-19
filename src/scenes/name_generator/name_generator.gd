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

class_name NameGenerator
extends Object

enum {FEMALE, MALE}

const SEX_NAME := {
	true: "male",
	false: "female"
}
const Sections := {
	"PEOPLE": "people",
	"NATIONS": "nations",
	"MECHS": "mechs",
}
const Values := {
	"PEOPLE": {
		"FIRST_MALE_NAMES": "first_male_names",
		"FIRST_FEMALE_NAMES": "first_female_names",
		"LAST_NAMES": "last_names",
		"NICKNAME_ADJECTIVES": "nickname_adjectives",
		"NICKNAME_NOUNS": "nickname_nouns",
		"SUFFIXES": "suffixes",
		"NUMERAL_SUFFIXES": "numeral_suffixes",
		"COMMON_MALE_PREFIXES": "common_male_prefixes",
		"COMMON_FEMALE_PREFIXES": "common_female_prefixes",
		"UNCOMMON_MALE_PREFIXES": "uncommon_male_prefixes",
		"UNCOMMON_FEMALE_PREFIXES": "uncommon_female_prefixes",
	},
	"NATIONS": {
		"NAMES": "names",
		"CITIES": "cities",
	},
	"MECHS": {"NAMES": "names"},
}

const WORD_LIST_LOCATION: String = "res://wordlist"
var word_list := ConfigFile.new()

func _init():
	randomize()
	var err: int = word_list.load(WORD_LIST_LOCATION)
	if err != OK:
		push_error("Could not load " + WORD_LIST_LOCATION + ". Error " + str(err))


func get_id() -> Dictionary:
	var sex: bool = get_sex()

	return {
		"sex": SEX_NAME[sex],
		"prefix": get_prefix(sex),
		"name": get_person_name(sex),
		"nickname": get_nickname(),
		"suffix": get_suffix()
	}


func get_sex() -> bool:
	if randf() > 0.5:
		return true
	return false


func get_prefix(male := true) -> String:
	var type: String
	if randf() > 0.25:
		if male:
			type = Values.PEOPLE.COMMON_MALE_PREFIXES
		else:
			type = Values.PEOPLE.COMMON_FEMALE_PREFIXES
	else:
		if male:
			type = Values.PEOPLE.UNCOMMON_MALE_PREFIXES
		else:
			type = Values.PEOPLE.UNCOMMON_FEMALE_PREFIXES

	var prefixes: Array
	prefixes = word_list.get_value(Sections.PEOPLE, type)

	return prefixes[randi() % prefixes.size()]


func get_person_name(male := true) -> String:
	var type: String
	if male:
		type = Values.PEOPLE.FIRST_MALE_NAMES
	else:
		type = Values.PEOPLE.FIRST_FEMALE_NAMES

	var first_names: Array
	var last_names: Array
	first_names = word_list.get_value(Sections.PEOPLE, type)
	last_names = word_list.get_value(Sections.PEOPLE, Values.PEOPLE.LAST_NAMES)

	return _random_element(first_names) + " "\
			+ _random_element(last_names)


func get_nickname():
	var nickname: String = ""
	var nouns = word_list.get_value(Sections.PEOPLE, Values.PEOPLE.NICKNAME_NOUNS)
	var adjectives = word_list.get_value(Sections.PEOPLE, Values.PEOPLE.NICKNAME_ADJECTIVES)

	if randf() < 0.33:
		nickname += "The "

	if randf() < 0.5:
		nickname += _random_element(nouns)
		if randf() > 0.3:
			nickname += " " + _random_element(nouns)
	else:
		nickname += _random_element(adjectives)
		if randf() > 0.3:
			nickname += " " + _random_element(nouns)

	return nickname


func get_suffix() -> String:
	if randf() > 0.15:
		return ""

	var type: String
	if randf() > 0.5:
		type = Values.PEOPLE.NUMERAL_SUFFIXES
	else:
		type = Values.PEOPLE.NUMERAL_SUFFIXES

	var suffixes: Array = word_list.get_value(Sections.PEOPLE, type)

	return suffixes[randi() % suffixes.size()]


func _random_element(array: Array):
	return array[randi() % array.size()]
