# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mighty-mite}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lukas Rieder"]
  s.date = %q{2009-05-22}
  s.default_executable = %q{mite}
  s.description = %q{A simple command line interface for mite, a sleek time tracking webapp.}
  s.email = %q{l.rieder@gmail.com}
  s.executables = ["mite"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "TODO",
     "VERSION",
     "bin/mite",
     "lib/mighty_mite.rb",
     "lib/mighty_mite/application.rb",
     "lib/mighty_mite/autocomplete.rb",
     "lib/mite_ext.rb",
     "lib/string_ext.rb",
     "mighty-mite.gemspec",
     "spec/spec_helper.rb",
     "spec/unit/mighty_mite/application_spec.rb",
     "spec/unit/mighty_mite/autocomplete_spec.rb",
     "spec/unit/mighty_mite_spec.rb",
     "spec/unit/mite_ext_spec.rb",
     "spec/unit/string_ext_spec.rb",
     "vendor/yolk-mite-rb-0.0.3/CHANGES.txt",
     "vendor/yolk-mite-rb-0.0.3/LICENSE",
     "vendor/yolk-mite-rb-0.0.3/README.textile",
     "vendor/yolk-mite-rb-0.0.3/Rakefile",
     "vendor/yolk-mite-rb-0.0.3/VERSION.yml",
     "vendor/yolk-mite-rb-0.0.3/lib/mite-rb.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/customer.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/project.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/service.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/time_entry.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/time_entry_group.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/tracker.rb",
     "vendor/yolk-mite-rb-0.0.3/lib/mite/user.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/Overbryd/mighty-mite}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple command line interface for basic mite tasks.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/unit/mighty_mite/application_spec.rb",
     "spec/unit/mighty_mite/autocomplete_spec.rb",
     "spec/unit/mighty_mite_spec.rb",
     "spec/unit/mite_ext_spec.rb",
     "spec/unit/string_ext_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
