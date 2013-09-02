#
# Author:: Seigo Uchida (<spesnova@gmail.com>)
# Cookbook Name:: kandan 
# Attributes:: default
#
# Copyright (C) 2013 Seigo Uchida (<spesnova@gmail.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default["kandan"]["path"]           = "/opt/kandan"
default["kandan"]["repo"]           = "https://github.com/spesnova/kandan.git"
default["kandan"]["revision"]       = "52d2011454f2503f455aa5344f6f6834b9efaa8e"
default["kandan"]["user"]           = "kandan"
default["kandan"]["group"]          = "kandan"
default["kandan"]["bundle_command"] = nil

# Database setting
default["kandan"]["database"]["host"]     = "localhost"
default["kandan"]["database"]["name"]     = "kandan"
default["kandan"]["database"]["username"] = "kandan"
default["kandan"]["database"]["password"] = "kandan"
default["kandan"]["database_master_role"] = "kandan_database_master"
