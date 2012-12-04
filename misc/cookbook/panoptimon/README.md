Panoptimon
==========

A system agent responsible for managing system metric collection & distribution.

Requirements
============

* OpenJDK 1.7.0
* Ruby Gem: eventmachine
* Ruby Gem: daemons
* Ruby Gem: thin
* Ruby Gem: riemann-client
* Ruby Gem: sys-filesystem

Recipes
=======

## default

Includes appropriate platform recipe.

### redhat

Installs & configures Panoptimon for Redhat & Redhat derivative platforms. 

Attributes
==========
* `node[:panoptimon][:user]`: User Panoptimon runs as.
* `node[:panoptimon][:group]`: Group Panoptimon runs as.
* `node[:panoptimon][:install_dir]`: Directory containing Panoptimon installation.
* `node[:panoptimon][:conf_dir]`: Configuration directory.
* `node[:panoptimon][:demo_dir]`: Demonstration base directory.
* `node[:panoptimon][:collectors]`: Array of collectors to enable.
* `node[:panoptimon][:plugins]`: Array of plugins to enable.

Usage
=====

This cookbook installs all the necessary requirements & configures a base installation of Panoptimon.

	"recipe['panoptimon]"






