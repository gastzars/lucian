require 'lucian_helper'

describe '#web', services: ["web-service"] do
  context 'users behavior', services: ["crud-service", "mongodb"] do

  end
end

describe '#realtime', services: ["realtime-service", "crud-service", "mongodb"] do
  it 'create a record to mongodb when recieve a rest api' do
    a = 20
    expect(a).to eq(21)    
  end

  context '#web', services: ["web-service"] do
    it 'create a record to mongodb when recieve a rest api, then shown at web service' do

    end
  end
end

describe '#scheduler', services: ["scheduler-worker", "redis", "crud-service", "mongodb"] do
  it 'create a record to mongodb every 2 minutes' do

  end

  context '#web', services: ["web-service"] do
    it 'create a record to mongodb every 2 minutes, then shown at web service' do

    end
  end

  it "pending"
end
