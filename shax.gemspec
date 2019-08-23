# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "shax"
  s.version     = "0.5.0"
  s.author      = "Steve Shreeve"
  s.email       = "steve.shreeve@gmail.com"
  s.summary     = "Shax is a Ruby gem that makes it easy to parse XML"
  s.description = "Useful for parsing XML into a standard Ruby object"
  s.homepage    = "https://github.com/shreeve/shax"
  s.license     = "MIT"
  s.files       = `git ls-files`.split("\n") - %w[.gitignore]
end
