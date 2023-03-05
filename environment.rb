require 'rubygems'
require 'bundler/setup'
require 'sidekiq'

require './sidekiq_settings'
require './workers/execute_ruby_worker'
require './workers/get_notifications_worker'
require './models/mention'
require './models/reply'
require 'active_support/core_ext/string/output_safety'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/hash/keys'


require 'faraday'

$mastodon = Faraday.new(
  url: ENV['MASTODON_URL'],
  headers: {'Content-Type' => 'application/json', "Authorization" => "Bearer #{ENV['MASTODON_ACCOUNT_TOKEN']}"}
) do |f|
  f.response :json
end

