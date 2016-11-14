require "spec_helper"

describe Lucian do
  it "has a version number" do
    expect(Lucian::VERSION).not_to be nil
  end

  it 'failed' do
    a = 10
    sleep 2
    expect(a).to eq(11)
  end

  it 'failed syntax' do
    sleep 2
    gas
  end

  it 'this is pending'
  it 'this is pending 2'
end
