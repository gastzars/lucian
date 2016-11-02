class HomeController < ApplicationController
  def index
    @data = JSON.parse(RestClient.get(ENV['crud-streams']))
  end
end
