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

class_name TimeStamp
extends Object

enum {
	HOURS_IN_DAY = 24,
	DAYS_IN_WEEK = 7,
	WEEKS_IN_SEASON = 20
}

const DAY_OF_WEEK := {
	1: "Monday",
	2: "Tuesday",
	3: "Wednesday",
	4: "Thursday",
	5: "Friday",
	6: "Saturday",
	7: "Sunday"
}

var _raw_hour: int = 0 setget set_raw_hour,get_raw_hour
var _raw_day: int setget ,get_raw_day
var _raw_week: int setget ,get_raw_week
var _raw_season: int setget ,get_raw_season

var _hour: int setget ,get_hour
var _day: int setget, get_day
var _week: int setget, get_week
var _season: int setget, get_season

func _init(raw_hour: int = 0):
	# warning-ignore:narrowing_conversion
	_raw_hour = max(raw_hour, 0)


func set_date(hour := 0, day := 1, week := 1, season := 0):
	# warning-ignore:narrowing_conversion
	_raw_hour = max(hour, 0)
	# warning-ignore:narrowing_conversion
	_raw_hour += max(day, 1) * HOURS_IN_DAY
	# warning-ignore:narrowing_conversion
	_raw_hour += max(week, 1) * DAYS_IN_WEEK * HOURS_IN_DAY
	# warning-ignore:narrowing_conversion
	_raw_hour += max(season, 0) * WEEKS_IN_SEASON * DAYS_IN_WEEK * HOURS_IN_DAY


func set_raw_hour(time: int) -> void:
	# warning-ignore:narrowing_conversion
	_raw_hour = max(time, 0)


func get_raw_hour() -> int:
	return _raw_hour


func get_raw_day() -> int:
	# warning-ignore:integer_division
	return _raw_hour / HOURS_IN_DAY


func get_raw_week() -> int:
	# warning-ignore:integer_division
	return get_raw_day() / DAYS_IN_WEEK


func get_raw_season() -> int:
	# warning-ignore:integer_division
	return get_raw_week() / WEEKS_IN_SEASON


func get_hour() -> int:
	return get_raw_hour() % HOURS_IN_DAY


func get_day() -> int:
	return get_raw_day() % DAYS_IN_WEEK + 1


func get_week() -> int:
	return get_raw_week() % WEEKS_IN_SEASON + 1


func get_season() -> int:
	return get_raw_season()


func date() -> String:
	return "%s %d/%d %d:00 " % [DAY_OF_WEEK[get_day()], get_week(), get_season(), get_hour()]


func get_day_of_week() -> String:
	return DAY_OF_WEEK[get_day()]
