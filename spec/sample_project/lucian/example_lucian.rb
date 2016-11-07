require 'lucian_helper'

describe '#web', services: [:web_service] do
  context 'users behavior', services: [:crud_service, :mongodb] do

  end
end

describe '#realtime', services: [:realtime_service, :crud_service, :mongodb] do
  it 'create a record to mongodb when recieve a rest api' do
    a = 20
    expect(a).to eq(21)    
  end

  context '#web', services: [:web_service] do
    it 'create a record to mongodb when recieve a rest api, then shown at web service' do

    end
  end
end

describe '#scheduler', services: [:scheduler_service, :redis, :crud_service, :mongodb] do
  it 'create a record to mongodb every 2 minutes' do

  end

  context '#web', services: [:web_service] do
    it 'create a record to mongodb every 2 minutes, then shown at web service' do

    end
  end
end
