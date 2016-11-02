class FeedController < ApplicationController
  def index
    RestClient.post(ENV['crud-streams'], {:post_id => params["post_id"]})
    render json: {"success": true}
  end
end
