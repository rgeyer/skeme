# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{skeme}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan J. Geyer"]
  s.date = %q{2011-07-07}
  s.description = %q{= skeme

Skeme is a library for tagging objects (server instances, storage volumes, etc).  It is intended to allow tagging of the same resource in multiple systems simultaneously.

Currenly Skeme supports the following cloud providers and management tools.  Also listed are which resources can be tagged for each provider or manager

__Cloud Providers__
* Amazon EC2
  * Amazon EC2 Server Instance
  * Amazon EC2 EBS Volume
  * Amazon EC2 EBS Snapshot

__Cloud Management Tools__
* RightScale
  * Amazon EC2 Server Instance
  * Amazon EC2 EBS Volume
  * Amazon EC2 EBS Snapshot

== Copyright

Copyright (c) 2011 Ryan Geyer. See LICENSE.txt for
further details.

}
  s.email = %q{me@ryangeyer.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "LICENSE.txt",
    "NOTICE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/cloud_providers/aws.rb",
    "lib/managers/rightscale.rb",
    "lib/skeme.rb",
    "skeme.gemspec",
    "test/helper.rb",
    "test/test_skeme.rb"
  ]
  s.homepage = %q{http://github.com/rgeyer/skeme}
  s.licenses = ["Apache2"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A cloud management tagging library}
  s.test_files = [
    "test/helper.rb",
    "test/test_skeme.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fog>, ["~> 0.9.0"])
      s.add_runtime_dependency(%q<rest_connection>, [">= 0.0.21"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<fog>, ["~> 0.9.0"])
      s.add_dependency(%q<rest_connection>, [">= 0.0.21"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<fog>, ["~> 0.9.0"])
    s.add_dependency(%q<rest_connection>, [">= 0.0.21"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

