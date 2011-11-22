source "http://rubygems.org"

# Specify your gem's dependencies in loquat.gemspec
gemspec

if RUBY_VERSION < "1.9"
	gem "wxruby", :require => "wx"
elsif RUBY_VERSION >= "1.9"
	gem "wxruby-ruby19", :require => "wx"
end
