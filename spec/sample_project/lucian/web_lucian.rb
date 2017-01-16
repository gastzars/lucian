describe '#web', services: ["web-service"] do
  before(:each) do
    # Sleep to make sure container is running up.
    sleep 5
  end

  context 'users behavior', services: ["crud-service", "mongodb"] do
    it "should appear 'List ids'" do
      page = RestClient.get('web-service:3500')
      body = page.body
      expect(body.include?("List ids")).to be_truthy
    end
  end
end

