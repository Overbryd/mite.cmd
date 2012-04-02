# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mite.cmd}
  s.version = "0.1.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lukas Rieder"]
  s.date = %q{2010-02-11}
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
     "lib/mite_cmd.rb",
     "lib/mite_cmd/application.rb",
     "lib/mite_cmd/autocomplete.rb",
     "lib/mite_ext.rb",
     "lib/string_ext.rb",
     "mite.cmd.gemspec",
     "spec/mite_cmd/application_spec.rb",
     "spec/mite_cmd/autocomplete_spec.rb",
     "spec/mite_cmd_spec.rb",
     "spec/mite_ext_spec.rb",
     "spec/spec_helper.rb",
     "spec/string_ext_spec.rb",
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
  s.homepage = %q{http://github.com/Overbryd/mite.cmd}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple command line interface for basic mite tasks.}
  s.test_files = [
    "spec/mite_cmd/application_spec.rb",
     "spec/mite_cmd/autocomplete_spec.rb",
     "spec/mite_cmd_spec.rb",
     "spec/mite_ext_spec.rb",
     "spec/spec_helper.rb",
     "spec/string_ext_spec.rb"
  ]

  s.add_runtime_dependency 'activeresource'
  s.add_runtime_dependency 'activesupport'

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
