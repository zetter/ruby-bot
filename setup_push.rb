require 'webpush'
require './environment'


key_pair = Webpush.generate_key
auth = Base64.urlsafe_encode64(Random.new.bytes(16))

response = $mastodon.post('api/v1/push/subscription') do |req| 
  req.body = {
    subscription: {
      endpoint: "#{ENV.fetch('HOST_URL')}/push",
      keys: {
        p256dh: key_pair.public_key,
        auth:
      }
    },
    data: {
      alerts: {
        mention: true
      },
      policy: "all"
    }
  }.to_json
end

puts 'COMPLETED'
puts response.body.inspect