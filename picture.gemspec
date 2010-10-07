# encoding: utf-8

Gem::Specification.new do |s|
  s.name = 'fjomp_picture'
  s.version = "0.1.0"
  s.author = "Jonatan Magnusson"
  s.email = "joantan@cmteknik.se"
  s.platform = Gem::Platform::RUBY
  s.summary = "Basic picture handling for Rails applications"
  s.require_path = "lib"
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.rdoc"]
  
  s.files = Dir[
    'Rakefile',
    'lib/**/*',
    'rails/**/*',
    'test/**/*',
    'init.rb',
    'README*',
    'LICENSE*'
  ]

  s.require_path = 'lib'
end
