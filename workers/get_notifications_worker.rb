class GetNotificationsWorker
  include Sidekiq::Job

  def perform
    $mastodon.get('/api/v1/notifications?types[]=mention').body.each do |notification|
      id = notification.fetch('id')
      status_id = notification.dig('status', 'id')

      puts "Got notification #{id}, for status #{status_id}"      
      ExecuteRubyWorker.perform_async(status_id)
      
      $mastodon.post("/api/v1/notifications/#{id}/dismiss")
    end
  end
end