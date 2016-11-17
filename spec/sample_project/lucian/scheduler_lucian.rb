describe '#scheduler', services: ["scheduler-worker", "redis", "crud-service", "mongodb"] do

  Mongoid::Config.clients[:default] = {:database => "crud_development", :hosts => ["mongodb:27017"]}
  ENV["MONGOID_ENV"] = "default"

  class Stream
    include Mongoid::Document
    field :post_id,            :type => String
  end

  it 'create a record to mongodb every 1 minutes' do
    counter = Stream.count
    sleep(60)
    expect(Stream.count).to be > counter
  end

  context '#web', services: ["web-service"] do
    it 'create a record to mongodb every 1 minutes, then shown at web service' do
      old_page = RestClient.get('web-service:3500')
      old_body = old_page.body
      sleep(60)
      new_page = RestClient.get('web-service:3500')
      new_body = new_page.body
      expect(new_body.length).to be > old_body.length
    end
  end

end
