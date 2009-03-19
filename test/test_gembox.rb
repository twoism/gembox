require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../lib/gembox")

describe Gembox do
  before(:each) do
    @gb = Gembox.new
    @cfg_file_path = File.expand_path(File.dirname(__FILE__)) + '/sample.gemboxrc.yml'
  end
  
  it "should load the current users config file" do    
    cfg = @gb.load_yaml @cfg_file_path
    cfg.should_not be_nil
  end
    
  it "should skip config file if not found" do    
    cfg = @gb.load_yaml "~/some/random/path"
    cfg.should be_nil
  end
      
  it "should find .gemboxrc" do    
    home =  `cd ~/ && pwd`.chomp
    cfg = @gb.load_yaml "#{home}/.gemboxrc"
    cfg.should_not be_nil
  end

end