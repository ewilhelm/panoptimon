# Cookbook Name:: panoptimon
# Recipe:: default
#
# Copyright 2012, Sourcefire
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'centos', 'redhat', 'fedora', 'scientific'
  include_recipe 'panoptimon::redhat'
end

  
