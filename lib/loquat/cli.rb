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
  # options related to exerb command
  method_option :outfile, :type => :string, :aliases => "-o", :desc => "specifies output file."
  method_option :corename, :type => :string, :aliases => "-c", :desc => "specifies exerb-core by defined name."
  method_option :corefile, :type => :string, :aliases => "-C", :desc => "specifies exerb-core by path."
  method_option :kcode, :type => :string, :aliases => "-k", :desc => "specifies character code-set.", :banner => "none/euc/sjis/utf8"
  method_option :archive, :type => :boolean, :aliases => "-a", :desc => "create an archive only."
  method_option :verbose, :type => :boolean, :default => false, :aliases => "-v", :desc => "enable verbose mode."
  def build(src)
    # *.rb と同名の * ファイルを作成し、そこから起動する。
    # example.rb => example, example.exy
    # 同名の * ファイルの中身は起動に必要な処理
    exy = src.sub(/\..*/, ".exy")
    boot = src.sub(/\..*/, "")
    
    boot_src = File.expand_path( File.join(__FILE__, "..", "boot.erb") )
    open(boot, "w"){ |f| f.print ERB.new(IO.read(boot_src)).result(binding)  }
    
    outfile  = !options.outfile.nil?  ? "-o '#{options.outfile}'"  : ""
    corename = !options.corename.nil? ? "-c '#{options.corename}'" : ""
    corefile = !options.corefile.nil? ? "-C '#{options.corefile}'" : ""
    kcode    = !options.kcode.nil?    ? "-k '#{options.kcode}'"    : ""
    archive  = options.archive? ? "-a" : ""
    verbose  = options.verbose? ? "-v" : ""

    Bat.exec <<-EOS
      call mkexy #{boot} #{src}
      call loquat execlude_rubygems #{exy}
      call exerb #{corename} #{corefile} #{kcode} #{archive} #{verbose} #{exy} #{outfile}
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
