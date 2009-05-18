require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mighty-mite"
    gem.summary = "A simple command line interface for basic mite tasks."
    gem.email = "l.rieder@gmail.com"
    gem.homepage = "http://github.com/Overbryd/mighty-mite"
    gem.description = "A simple command line interface for mite, a sleek time tracking webapp."
    gem.authors = ["Lukas Rieder"]
    gem.add_dependency('mite-rb', ['>= 0.3.0'])
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
task :spec do
  sh "spec spec/unit/* --format specdoc --color"
end
task :default => :spec