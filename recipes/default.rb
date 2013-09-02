#
# Cookbook Name:: kandan
# Recipe:: default
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

include_recipe "git"
include_recipe "runit"

# Create a user for kandan app
user node["kandan"]["user"] do
  system true
end

# Install mysql client
include_recipe "mysql::ruby"

# Create the sub direcory under the shared
%w{ tmp public config pids log }.each do |dir|
  directory "#{node['kandan']['path']}/shared/#{dir}" do
    owner node["kandan"]["user"]
    group node["kandan"]["user"]
    mode "0755"
    recursive true
  end
end

case node["platform_family"]
when "rhel", "fedora"
  require_packages = %w{ gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel rubygem-nokogiri }
else
  require_packages = nil
end

# Deploy the app
application "kandan" do
  action :deploy
  path node["kandan"]["path"]
  owner node["kandan"]["user"]
  group node["kandan"]["group"]
  environment_name "production"

  packages require_packages

  repository node["kandan"]["repo"]
  revision node["kandan"]["revision"]

  # Symlink
#  purge_before_symlink %w{ log tmp/pids public/system config }
  create_dirs_before_symlink %w{ log tmp public config pids }
  symlinks "pids" => "tmp/pids",
           "log"  => "log"
#  symlink_before_migrate "config/database.yml" => "config/database.yml"

  # Migrate
  migrate true

  rails do
    use_omnibus_ruby false
    bundler true
    gems ["rake"]
    bundle_command node["kandan"]["bundle_command"]
    bundler_deployment true
    database_master_role node["kandan"]["database_master_role"] unless node["kandan"]["database"]["host"]
    database_template "custom_database.yml.erb" if node["kandan"]["database"]["host"]

    # FIXME
    # see http://lists.opscode.com/sympa/arc/chef/2013-07/msg00116.html
    database_params = {
      :host     => node["kandan"]["database"]["host"],
      :name     => node["kandan"]["database"]["name"],
      :username => node["kandan"]["database"]["username"],
      :password => node["kandan"]["database"]["password"]
    }

    database do
      adapter  "mysql2"
      host     database_params[:host]
      database database_params[:name]
      username database_params[:username]
      password database_params[:password]
    end
    precompile_assets true
  end

  notifies :run, "execute[restart_thin_for_kandan]", :immediately
end

# FIXME
# use runit
execute "start_thin_for_kandan" do
  action :run
  command "/usr/local/rbenv/shims/bundle exec thin start -e production -p 80 -l log/thin.log -d"
  user "root"
  cwd "#{node['kandan']['path']}/current"
  not_if { ::File.exists?("#{node["kandan"]["path"]}/shared/pids/thin.pid") }
end
execute "restart_thin_for_kandan" do
  action :nothing
  command "/usr/local/rbenv/shims/bundle exec thin restart"
  user "root"
  cwd "#{node['kandan']['path']}/current"
end

# sudo /usr/local/rbenv/shims/bundle exec rake db:create db:migrate kandan:bootstrap RAILS_ENV=production
