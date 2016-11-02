require 'spec_helper'

describe Lucian::Initiator do
  current_dir = Dir.pwd

  # Change current directory to gem's root
  before(:each) {
    Dir.chdir current_dir
  }

  context '#init' do
    it 'can create "lucian" directory' do
      Lucian::Initiator.init
      expect(File.directory?(File.expand_path(current_dir+'/lucian'))).to be_truthy
      FileUtils.rm_rf(File.expand_path(current_dir+'/lucian'))
      expect(File.directory?(File.expand_path(current_dir+'/lucian'))).to be_falsy
    end  

    it 'can create "lucain/lucian_helper.rb" file' do
      Lucian::Initiator.init
      expect(File.exist?(File.expand_path(current_dir+'/lucian/lucian_helper.rb'))).to be_truthy
      FileUtils.rm_rf(File.expand_path(current_dir+'/lucian'))
      expect(File.exist?(File.expand_path(current_dir+'/lucian/lucian_helper.rb'))).to be_falsy
    end
  end
end
