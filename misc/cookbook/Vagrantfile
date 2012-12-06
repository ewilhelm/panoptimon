Vagrant::Config.run do |config|

  config.vm.define :panoptimon do |host|
    host.vm.box       = 'centos-63'
    host.vm.host_name = 'panoptimon.dev'
    host.vm.network   :hostonly, '192.168.2.101'
    host.vm.share_folder 'panoptimon', '/usr/local/panoptimon', File.join(File.join(File.dirname(__FILE__), '..', '..'))
    host.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = Dir.pwd
      chef.add_recipe('panoptimon')
      chef.json = {
        :panoptimon => {
          :user        => 'vagrant',
          :group       => 'vagrant',
          :install_dir => "/usr/local/panoptimon",
          :conf_dir    => "/usr/local/panoptimon/etc",
          :demo_dir    => "/etc/panoptimon/demo",
          :collectors  => ["cpu","disk","iostat","load","memory"],
          :plugins     => ["log_to_file", "riemann_stream", "status_http"]
        }
      }
    end
  end
end
