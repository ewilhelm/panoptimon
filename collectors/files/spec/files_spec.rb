#!/usr/bin/env ruby

require 'rspec'
load File.expand_path('../../files', __FILE__)
require 'ostruct'
require 'tmpdir'

describe('filters') {
  f = ->(props) { return OpenStruct.new(props) }
  it('passes with one true property') {
    filters(%w{directory}).call(f.call(directory?: true))
    .should == true
  }
  it('fails with one false property') {
    filters(%w{directory}).call(f.call(directory?: false))
    .should == false
  }
  it('passes with 2 true properties') {
    filters(%w{directory world_readable}).
      call(f.call(directory?: true, world_readable?: true))
    .should == true
  }
  it('passes with 3 true properties') {
    filters(%w{directory world_readable world_writable}).
      call(f.call(directory?: true, world_readable?: true,
        world_writable?: true))
    .should == true
  }
  it('fails with some false properties') {
    filters(%w{directory world_readable world_writable}).
      call(f.call(directory?: true, world_readable?: true,
        world_writable?: false))
    .should == false
  }
  it('works for real tmpdir (aka /tmp/)') {
    filters(%w{directory world_readable world_writable}).
      call(Pathname.new(Dir.tmpdir).stat)
    .should == true
  }
  it('works for real /') {
    filters(%w{directory world_readable}).
      call(Pathname.new('/').stat)
    .should == true
  }
  it('works for real /') {
    filters(%w{file world_readable}).
      call(Pathname.new('/').stat)
    .should == false
  }
  it('works for real / (or so one would hope)') {
    filters(%w{directory world_readable world_writable}).
      call(Pathname.new('/').stat)
    .should == false
  }

}

