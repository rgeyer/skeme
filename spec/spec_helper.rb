require 'rubygems'
require 'logger'
require 'bundler'
Bundler.setup

require 'rspec'
require 'yaml'

$creds_yo = YAML.load_file(File.join(File.dirname(__FILE__), 'creds.yml'))