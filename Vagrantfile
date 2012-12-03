Vagrant::Config.run do |config|

  config.vm.define :panoptimon do |host|
    host.vm.box       = 'centos-63'
    host.vm.host_name = 'panoptimon.dev'
    host.vm.network   :hostonly, '192.168.2.101'

    host.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = File.join(ENV['HOME'], 'Desktop', 'cookbooks')
      chef.add_recipe('panoptimon')
      chef.json = {
        :panoptimon => {
          :user       => 'vagrant',
          :group      => 'vagrant',
          :dir        => "/opt/src/panoptimon",
          :conf       => "/opt/src/panoptimon/etc",
          :demo       => "/opt/src/panoptimon/etc/demo",
          :url        => "https://github.com/synthesist/panoptimon.git",
          :collectors => ["cpu","disk","iostat","load","memory"],
          :plugins    => ["log_to_file", "riemann_stream", "status_http"]
        }
      }
    end
  end
end
