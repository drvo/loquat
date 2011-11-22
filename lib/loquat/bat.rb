# -*- encoding: UTF-8 -*-

require 'tempfile'
require 'kconv'

module Bat extend self
  def exec(src, &block)
    file, line = *caller(1)[0].match(/(.+):(\d+)/).to_a[1..-1]
    file = File.expand_path(file)
    line = line.to_i + 1

    # 全部の行に、エラーだったら終了するよう処理を追加
    next_noerror = false
    src_map = src.each_line.with_index.map do |s,i|
       if s.match(/^\s$/)
         s
       elsif s.match(/^\s*(rem\s+|::)skip_error/)
         next_noerror = true
         s
       elsif next_noerror
         next_noerror = false
         s
       else
         ret = <<-EOSA
           #{s}
           @if %errorlevel% == 9009 if NOT "%no_error_break%" == "1" echo You do not have #{s.match(/\w+/).to_a[0]} in your PATH. && exit
           @if errorlevel 1  if NOT "%no_error_break%" == "1" echo #{file}(#{line + i}): #{s.gsub("\n", "").gsub(/\&/, "\\&")} && echo if you write comment ** "::skip_error" or "rem skip_error" ** to not error stop && exit
           @set error_no_break=0
         EOSA
      end
    end
    src = src_map.join
    Tempfile.open(["", ".bat"]) do |f|
      f.puts src.tosjis
      f.close
      system("#{f.path} 2>&1")
    end
  end
end

if __FILE__ == $0
  Bat.exec <<-'EOS'
    rem @echo off
    cd L:\Work\MG3710IQPro\Develop
    dir
  EOS
end
