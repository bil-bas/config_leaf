#!/usr/bin/env rake
require 'bundler/setup'

require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'
require 'rspec/core/rake_task'

CLOBBER.include('doc/**/*')

desc 'Generate Yard docs.'
task :yard do
  system 'yard doc lib'
end

RSpec::Core::RakeTask.new do
end

task default: :spec
