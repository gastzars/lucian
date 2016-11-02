require 'spec_helper'

describe Lucian::Core do
  current_dir = Dir.pwd

  # Change current directory to gem's root
  before(:each) {
    Dir.chdir current_dir
  }

  it 'can fetch parent docker-compose.yml' do
    Dir.chdir './spec/sample_project/projects'
    lucian_core = Lucian::Core.new
    expect(lucian_core.compose_file).to eq(File.expand_path('./../docker-compose.yml'))
  end

  it 'raise error when docker-compose path is invalid' do
    expect{ Lucian::Core.new('./some-randompath') }.to raise_error(Lucian::Error)
  end

  it 'can load yaml into object when docker-compose path is valid' do
    lucian_core = Lucian::Core.new('./spec/sample_project/docker-compose.yml')
    expect(lucian_core.compose_data).to eq(YAML.load_file('./spec/sample_project/docker-compose.yml'))
  end

  it 'can find docker-compose directory when docker-compose path is valid' do
    Dir.chdir './spec/sample_project/projects'
    lucian_core = Lucian::Core.new
    expect(lucian_core.compose_directory).to eq(File.expand_path(current_dir+'/spec/sample_project'))
  end
end
