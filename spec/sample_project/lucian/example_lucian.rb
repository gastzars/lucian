require 'lucian_helper'

Lucian.describe '#web', services: [:web_service] do
  Lucian.context 'users behavior', services: [:crud_service, :mongodb] do

  end
end

Lucian.describe '#realtime', services: [:realtime_service, :crud_service, :mongodb] do
  Lucian.it 'create a record to mongodb when recieve a rest api' do
    
  end

  Lucian.context '#web', services: [:web_service] do
    Lucian.it 'create a record to mongodb when recieve a rest api, then shown at web service' do

    end
  end
end

Lucian.describe '#scheduler', services: [:scheduler_service, :redis, :crud_service, :mongodb] do
  Lucian.it 'create a record to mongodb every 2 minutes' do

  end

  Lucian.context '#web', services: [:web_service] do
    Lucian.it 'create a record to mongodb every 2 minutes, then shown at web service' do

    end
  end
end
