require 'yaml'
class Gembox
  VERSION = '1.0.0'
  attr_accessor :cfg
  
  def initialize
    @cfg_path =  `cd ~/ && pwd`.chomp + "/.gemboxrc"
    load_config
  end
  
  def self.create(args)
    dir = Dir.new(Dir.pwd+"/"+args.shift).path
    Dir.chdir(dir)
    dir = Dir.pwd
    FileUtils.mkdir_p "#{dir}/usr/bin"
    FileUtils.mkdir_p "#{dir}/gems"  
    File.open("#{dir}/.gemrc", 'w') do |f|
      f.puts "gempath:"
      f.puts "  - #{dir}/gems"
    end
    File.open("#{dir}/.bashrc", "w") do |f|
      f.puts "PS1=\"gembox:\\w> \""
      f.puts "export PATH=#{dir}/usr/bin:\$PATH"
      f.puts "alias gem='ruby #{dir}/dispatch.rb'"
      f.puts "export GEM_PATH=#{dir}/gems"
      f.puts "export GEM_HOME=#{dir}/gems"
    end
    File.open("#{dir}/shell.bash", "w") do |f|
      f.puts "/usr/bin/env bash --rcfile #{dir}/.bashrc"
    end
    File.open("#{dir}/dispatch.rb", "w") do |f|
      f.puts "#!/usr/bin/ruby"
      f.puts "args=ARGV"
      f.puts "command=args.shift"
      f.puts "case command"
      f.puts "when 'install'"
      f.puts "  system(\"gem --config-file #{dir}/.gemrc #\{command\} --bindir #{dir}/usr/bin #\{ARGV.join(' ')\}\")"
      f.puts "else"
      f.puts "  system(\"gem --config-file #{dir}/.gemrc #\{command\} #\{ARGV.join(' ')\}\")"
      f.puts "end"
    end
  end
  
  def self.shell(args)
    system("sh shell.bash")
  end
  
  def load_config
    @cfg = load_yaml(@cfg_path)
  end
  
  def load_yaml path
    File.exists?(path) ? YAML.load(File.open(path)) : nil
  end
  
end
