class FeedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ids = rand(1..4).times.collect do
      "#{rand(1000000000..9999999999)}_#{rand(1000000000..9999999999)}"
    end
    ids.each do |id|
      RestClient.post(ENV['crud-streams'], {"post_id" => id})
    end
  end
end

Sidekiq::Cron::Job.create(name: 'Feed page every 1 min', cron: '* * * * *', class: 'FeedJob')
