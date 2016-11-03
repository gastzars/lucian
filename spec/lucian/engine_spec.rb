require 'spec_helper'

describe Lucian::Engine do
  current_dir = Dir.pwd

  # Change current directory to gem's root
  before(:each) {
    Dir.chdir current_dir
  }

  context '#initialize' do
    it 'can fetch parent docker-compose.yml' do
      Dir.chdir './spec/sample_project/projects'
      lucian_core = Lucian::Engine.new
      expect(lucian_core.compose_file).to eq(File.expand_path('./../docker-compose.yml'))
    end

    it 'raise error when docker-compose path is invalid' do
      expect{ Lucian::Engine.new('./some-randompath') }.to raise_error(Lucian::Error)
    end

    it 'can load yaml into object when docker-compose path is valid' do
      lucian_core = Lucian::Engine.new('./spec/sample_project/docker-compose.yml')
      expect(lucian_core.compose_data).to eq(YAML.load_file('./spec/sample_project/docker-compose.yml'))
    end

    it 'can find docker-compose directory when docker-compose path is valid' do
      Dir.chdir './spec/sample_project/projects'
      lucian_core = Lucian::Engine.new
      expect(lucian_core.compose_directory).to eq(File.expand_path(current_dir+'/spec/sample_project'))
    end

    it 'can fetch *_lucian.rb files' do
      Dir.chdir './spec/sample_project/projects'
      lucian_core = Lucian::Engine.new
      expect(lucian_core.lucian_files).to include(File.expand_path(current_dir+'/spec/sample_project/lucian/example_lucian.rb'))
      expect(lucian_core.lucian_files).to include(File.expand_path(current_dir+'/spec/sample_project/lucian/subdir/subdir_lucian.rb'))
    end

    
  end
end
