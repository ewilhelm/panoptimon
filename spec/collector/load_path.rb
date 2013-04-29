#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon'
require 'tempfile'

describe "PATH search" do
  before(:each) do
    @test_bin_dir = "/tmp/panoptimon/testdir/"
    FileUtils.mkdir_p @test_bin_dir
    fakepath = @test_bin_dir + ":/should/not/exist/"
    ENV["PATH"] = fakepath

    test_conf_dir = Pathname.new "/tmp/panoptimon/test_conf/"
    FileUtils.mkdir_p test_conf_dir

    @test_conf_path = test_conf_dir + "thing.json"
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

  after(:each) do
    FileUtils.rm_rf @test_bin_dir
    FileUtils.rm_rf @test_conf_path
  end
end
