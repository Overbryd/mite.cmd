require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mighty-mite"
    gem.executables = "mite"
    gem.summary = "A simple command line interface for basic mite tasks."
    gem.email = "l.rieder@gmail.com"
    gem.homepage = "http://github.com/Overbryd/mighty-mite"
    gem.description = "A simple command line interface for mite, a sleek time tracking webapp."
    gem.authors = ["Lukas Rieder"]
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

task :spec do
  sh "spec spec/unit/* --format specdoc --color"
end
task :default => :spec

task :rcov do
  sh "rake run_rcov && open coverage/index.html"
end
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:run_rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end