default['panoptimon']['user']          = 'vagrant'
default['panoptimon']['group']         = 'vagrant'
default['panoptimon']['install_dir']   = '/usr/local/panoptimon'
default['panoptimon']['conf_dir']      = '/usr/local/etc/panoptimon'
default['panoptimon']['demo_dir']      = '/usr/local/etc/panoptimon/demo'
default['panoptimon']['collectors']    = %w[cpu disk iostat load memory]
default['panoptimon']['plugins']       = %w[log_to_file reimann_stream status_http]
