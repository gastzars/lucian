describe '#realtime', services: ["realtime-service", "crud-service", "mongodb"] do

  before(:each) do
    # Sleep to make sure container is running up.
    sleep 5
  end

  Mongoid::Config.clients[:default] = {:database => "crud_development", :hosts => ["mongodb:27017"]}
  ENV["MONGOID_ENV"] = "default"

  class Stream
    include Mongoid::Document
    field :post_id,            :type => String
  end

  it 'create a record to mongodb when recieve a rest api' do
    id = "#{rand(100000.999999)}..#{rand(100000..999999)}"
    RestClient.post('realtime-service:3501/feed', {:post_id => id.to_s})
    sleep(1)
    stream = Stream.where(:post_id => id).to_a
    expect(stream).not_to be_nil
  end

  context '#web', services: ["web-service"] do
    it 'create a record to mongodb when recieve a rest api, then shown at web service' do
      id = "#{rand(100000.999999)}..#{rand(100000..999999)}"
      RestClient.post('realtime-service:3501/feed', {:post_id => id.to_s})
      sleep(1)
      body = RestClient.get('web-service:3500').body
      expect(body.include?(id)).to be_truthy
    end
  end
end
