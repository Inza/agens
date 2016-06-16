# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "agens"
  gem.homepage = "http://github.com/Inza/agens"
  gem.license = "MIT"
  gem.summary = %Q{Framework for Multi-Agent Systems in Ruby}
  gem.description = %Q{Agents is a framework for building Multi-Agent Systems (MAS) in Ruby. With support of COPL (Concurrency-Oriented Programming Language - thx to Celluloid) and Neural Nets (thx to ai4r).

We have built Agens in order to design Multi-Agent System (MAS) to drive our Probee Open Hardware robot. We wanted to build this MAS in Ruby.

Build with love in Prague.}
  gem.email = "tomas.jukin@juicymo.cz"
  gem.authors = ["Tomas Jukin"]
  
  gem.files = Dir.glob('lib/**/*.rb')

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "agens #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
