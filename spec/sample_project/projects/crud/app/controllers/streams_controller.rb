class StreamsController < ApplicationController
  def show
    render json: Stream.all.to_json
  end

  def create
    new_stream = Stream.new({:post_id => params["post_id"]})
    new_stream.save
    render json: new_stream.to_json
  end
end
