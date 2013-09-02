# kandan cookbook
This cookbook is designed to deploy the Kandan application.

Currently supported:

* Deploy the kandan app from the source
* Install and Manage MySQL by using the opscode officail recipe

# Requirements
## Platform

* RHEL

## Cookbook

* git
* application_ruby
* database
* mysql

# Usage
Include the recipe on your node or role that fits how you wish to install Kandan on your system per the recipes section above. Modify the attributes as required in your role to change how various configuration is applied per the attributes section above. In general, override attributes in the role should be used when changing attributes.

# Attributes

* `node["kandan"]["path"]` - The path to deploy kandan.
* `node["kandan"]["repo"]` - The repository url for kandan.
* `node["kandan"]["revision"]` - The revision to deploy.
* `node["kandan"]["user"]` - The kandan system user
* `node["kandan"]["group"]` - The kandan system group
* `node["kandan"]["bundle_command"]` - See [application_ruby cookbook's README](https://github.com/opscode-cookbooks/application_ruby)
* `node["kandan"]["host"]` - The database master host. If you want to set host dynamically, specify `nil`.
* `node["kandan"]["name"]` - The database name for kandan.
* `node["kandan"]["username"]` - The database username for kandan.
* `node["kandan"]["password"]` - The database password for kandan.
* `node["kandan"]["database_master_role"]` - The role database master has.
 

# Recipes
## kandan::default
This recipe deploy the kandan app.

## kandan::mysql
This recipe install and configure mysql server for kandan.

# License and Author

Author:: Seigo Uchida (<spesnova@gmail.com>)

Copyright:: 2013 Seigo Uchida (<spesnova@gmail.com>)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
