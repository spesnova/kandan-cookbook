#
# Cookbook Name:: kandan
# Recipe:: mysql
#
# Copyright (C) 2013 Seigo Uchida
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# MySQL password setting
if data_bag_item("kandan", "database") && Chef::Config[:solo] == false
  node.normal["kandan"]["database"]["password"]  = data_bag_item("kandan", "database")["user_password"]
  node.normal["mysql"]["server_root_password"]   = data_bag_item("kandan", "database")["root_password"]
  node.normal["mysql"]["server_repl_password"]   = data_bag_item("kandan", "database")["repl_password"]
  node.normal["mysql"]["server_debian_password"] = data_bag_item("kandan", "database")["debian_password"]
end

include_recipe "mysql::server"

service "mysqld" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

mysql_database node["kandan"]["database"]["name"] do
  connection connection_info
  action :create
end

mysql_database_user node["kandan"]["database"]["username"] do
  connection connection_info
  password node["kandan"]["database"]["password"]
  action :create
end

mysql_database_user node["kandan"]["database"]["username"] do
  connection connection_info
  database_name node["kandan"]["database"]["name"]
  privileges [:all]
  password node["kandan"]["database"]["password"]
  action :grant
end
