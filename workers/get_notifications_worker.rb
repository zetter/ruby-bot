class GetNotificationsWoker
  include Sidekiq::Job

  def perform
    $mastodon.get('/api/v1/notifications').each do |notification|
      id = notification.fetch('id')
      sender = notification.dig('account', 'acct')
      status_id = notification.dig('status', 'id')
      status_url = notification.dig('status', 'url')
      content = notification.dig('status', 'content')

      $mastodon.post("/api/v1/notifications/#{id}/dismiss")
      
      puts {
        id:,
        sender:,
        status_id:,
        status_url:,
        content:
      }.inspect
    end
  end
end