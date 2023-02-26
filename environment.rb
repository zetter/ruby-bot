require 'rubygems'
require 'bundler/setup'
require 'sidekiq'

require './sidekiq_settings'
require './workers/execute_ruby_worker'
require './workers/get_notifications_worker'

require 'faraday'

$mastodon = Faraday.new(
  url: ENV['MASTODON_URL'],
  headers: {'Content-Type' => 'application/json', "Authorization" => "Bearer #{ENV['MASTODON_ACCOUNT_TOKEN']}"}
) do |f|
  f.response :json
end

