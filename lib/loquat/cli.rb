# -*- encoding: UTF-8 -*-

require "rubygems"
require "thor"
require "loquat/bat"
require "yaml"
require "fileutils"
require "erb"

class LoquatCli < Thor
  namespace :loquat

  desc "build src", "exe化"
  def build(src)
    # *.rb と同名の * ファイルを作成し、そこから起動する。
    # example.rb => example, example.exy
    # 同名の * ファイルの中身は起動に必要な処理
    exy = src.sub(/\..*/, ".exy")
    boot = src.sub(/\..*/, "")
    
    boot_src = File.expand_path( File.join(__FILE__, "..", "boot.erb") )
    open(boot, "w"){ |f| f.print ERB.new(IO.read(boot_src)).result(binding)  }

    Bat.exec <<-EOS
      call mkexy #{boot} #{src}
      call loquat execlude_rubygems #{exy}
      call exerb #{exy}
      del #{boot}
    EOS
  end
  
  desc "execlude_rubygems", "exy ファイルから rubygems 関連のファイルを抜く"
  def execlude_rubygems(exy)
    h = YAML.load_file exy
    h["file"].reject!{|k,v| k.match(/^rubygems/) }
    open(exy,"w"){|f| f.print YAML.dump(h) }
  end
end

LoquatCli.start
