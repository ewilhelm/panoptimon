#!/usr/bin/env ruby

require 'rspec'
require 'panoptimon'
require 'tempfile'

describe "PATH search" do
  before(:each) do
    @testdir = "/tmp/panoptimon/testdir/"
    FileUtils.mkdir_p @testdir
    fakepath = @testdir + ":/should/not/exist/"
    ENV["PATH"] = fakepath
    @monitor = Panoptimon::Monitor.new
  end

  it "should return nil if no file is found" do
    expect(@monitor._autodetect_collector_command_path("bad_collector")).to be_nil
  end

  it "should return a path if the command is found" do
    path = File.join(@testdir, "pancollect-thing")
    f = File.new(path, "w")
    expect(@monitor._autodetect_collector_command_path("thing")).to eq(path)
  end
end
