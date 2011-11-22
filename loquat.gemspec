# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "loquat/version"

Gem::Specification.new do |s|
  s.name        = "loquat"
  s.version     = Loquat::VERSION
  s.authors     = ["drvo"]
  s.email       = ["drvo.gm@gmail.com"]
  s.homepage    = "http://www35150u.sakura.ne.jp/redmine/projects/loquat"
  s.summary     = %q{Supports conversion from wxruby script to exe}
  s.description = <<EOS
wxruby script から exe への変換をサポート
exerb が必要
exerb で exe に変換する際に問題となる gem 利用を程度解決
GUI実行時のDOS画面非表示化
Exception 発生時に再表示

Supports conversion from wxruby script to exe
Need exerb
solve a problem about the use of gem when converting to exe by exerb
Hiding the DOS window when running GUI
Reappear when an Exception
EOS

  s.rubyforge_project = "loquat"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
