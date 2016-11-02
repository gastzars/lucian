class FeedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    graph = Koala::Facebook::API.new(Scheduler::AccessToken["access_token"])
    data = graph.get_object("#{Scheduler::AccessToken["page_id"]}/feed", {})
    ids = data.collect{|_d| _d["id"] }
    ids.each do |id|
      RestClient.post(ENV['crud-streams'], {"post_id" => id})
    end
  end
end

Sidekiq::Cron::Job.create(name: 'Feed page every 2 min', cron: '*/2 * * * *', class: 'FeedJob')
