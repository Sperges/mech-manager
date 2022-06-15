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

class_name Mail, "mail.svg"
extends Resource

enum Type {OK, YES_NO}

export(Type) var type: int = Type.OK
export(String) var title: String
export(String) var sender: String
export(String) var date: String
export(String, MULTILINE) var body: String
export(String) var footer: String
export(String) var tooltip: String
export(bool) var rich_text: bool = false
