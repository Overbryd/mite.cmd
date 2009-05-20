task :default => [:spec]
 
$gem_name = "mite-rb"
 
desc "Run specs"
task :spec do
  sh "spec spec/* --format specdoc --color"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = $gem_name
    s.summary = "The official ruby library for interacting with the RESTful API of mite, a sleek time tracking webapp."
    s.email = "sebastian@yo.lk"
    s.homepage = "http://github.com/yolk/mite-rb"
    s.description = "The official ruby library for interacting with the RESTful mite.api."
    s.authors = ["Sebastian Munz"]
    s.add_dependency(%q<activesupport>, [">= 2.3.2"])
    s.add_dependency(%q<activeresource>, [">= 2.3.2"])
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
