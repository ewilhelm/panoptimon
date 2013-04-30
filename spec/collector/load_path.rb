#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon'

describe "PATH search" do
  before(:each) do
    @test_bin_dir = "/tmp/panoptimon/test_bin/"
    FileUtils.mkdir_p @test_bin_dir
    fakepath = @test_bin_dir + ":/should/not/exist/"
    ENV["PATH"] = fakepath

    @test_conf_dir = Pathname.new "/tmp/panoptimon/test_conf/"
    FileUtils.mkdir_p @test_conf_dir

    @test_collector_name = "thing"
    @test_conf_path = @test_conf_dir + "#{@test_collector_name}.json"
    f = File.new(@test_conf_path, "w")
    f.write('{"hey": "yo"}')
    f.close

    @monitor = Panoptimon::Monitor.new(
      config: Panoptimon.load_options(['-c', '',
        '-o', 'collector_interval=9',
        '-o', 'collector_timeout=12',
        ])
      )
  end

  it "should return nil if no file is found" do
    expect(@monitor._autodetect_collector_command_path("bad_collector")).to be_nil

    @monitor._load_collector_config(@test_conf_path).should include(:command => nil)
  end

  it "should return a path if the command is found" do
    path = File.join(@test_bin_dir, "pancollect-thing")
    f = File.new(path, "w")
    f.close
    expect(@monitor._autodetect_collector_command_path("thing")).to eq(path)

    @monitor._load_collector_config(@test_conf_path).should include(:command => path)
  end

  it "should not search PATH if exec is stipulated" do
    path = File.join(@test_bin_dir, "pancollect-thing")
    f = File.new(path, "w")
    f.close

    # Non-absolute exec path
    f = File.new(@test_conf_path, 'w')
    f.write('{"exec": "something_else"}')
    f.close
    non_abs_exec_path = @test_conf_dir.join(@test_collector_name, "something_else")

    @monitor._load_collector_config(@test_conf_path).should include(:command => non_abs_exec_path)

    # Absolute exec path
    f = File.new(@test_conf_path, 'w')
    exec_cmd = Pathname.new('/usr/bin/true')
    f.write("{\"exec\": \"#{exec_cmd}\"}")
    f.close

    @monitor._load_collector_config(@test_conf_path).should include(:command => exec_cmd)
  end

  after(:each) do
    FileUtils.rm_rf @test_bin_dir
    FileUtils.rm_rf @test_conf_path
  end
end
