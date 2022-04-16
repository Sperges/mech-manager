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

# KEY: TimeStamp.date()
# VALUE: [Event]
var _schedule := {}

func add_event(event: Event, time: TimeStamp) -> void:
	var date: String = time.date()

	if _schedule.get(date):
		_schedule[date].append(event)
		return

	_schedule[date] = [event]


func delete_event(event: Event, time: TimeStamp) -> void:
	var date: String = time.date()

	if not _schedule.get(date):
		return

	_schedule[date].erase(event)

	if _schedule[date].empty():
		_schedule.erase(date)


func get_events(time: TimeStamp) -> Array:
	return _schedule.get(time.date(), [])
