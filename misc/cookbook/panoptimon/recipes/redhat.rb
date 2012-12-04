# Cookbook Name:: panoptimon
# Recipe:: redhat
#
# Copyright 2012, Sourcefire
#
# All rights reserved - Do Not Redistribute
#
package 'java-1.7.0-openjdk'

%w[eventmachine daemons thin riemann-client sys-filesystem].each do |gem_pkg|
  gem_package gem_pkg
end

[ node[:panoptimon][:install_dir],
  node[:panoptimon][:conf_dir],
  node[:panoptimon][:demo_dir],
].each do |dir|
  directory dir do
    owner     node[:panoptimon][:user]
    group     node[:panoptimon][:group]
    mode      '0755'
    recursive true
  end
end

%w[collectors plugins].each do |dir|
  directory "#{node[:panoptimon][:demo_dir]}/#{dir}" do
    owner node[:panoptimon][:user]
    group node[:panoptimon][:group]
    mode  '0755'
  end
end

file "#{node[:panoptimon][:demo_dir]}/panoptimon.json" do
  owner   node[:panoptimon][:user]
  group   node[:panoptimon][:group]	
  mode    '0644'
  content '{"collector_interval" : 15}'
end

node[:panoptimon][:plugins].each do |plugin|
  link "#{node[:panoptimon][:demo_dir]}/plugins/#{plugin}" do
    to "#{node[:panoptimon][:install_dir]}/plugins/#{plugin}"
  end
end

node[:panoptimon][:collectors].each do |col|
  link "#{node[:panoptimon][:demo_dir]}/collectors/#{col}" do
    to "#{node[:panoptimon][:install_dir]}/collectors/#{col}"
  end
end