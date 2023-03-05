require 'puppeteer-ruby'
require 'nokogiri'

class ExecuteRubyWorker
  include Sidekiq::Job

  def perform(mention_id)
    puts "Executing #{mention_id}"
    response = $mastodon.get("/api/v1/statuses/#{mention_id}")
    mention = Mention.new(response.body)

    result = nil
    Puppeteer.launch(headless: true) do |browser|
      page = browser.new_page
      params = {
        program: mention.program
      }
      page.goto("https://ruby-bot.d2.chriszetter.com/ruby?#{params.to_param}")
      page.wait_for_selector('#result', timeout: 30_000)
      result = JSON.parse(page.eval_on_selector('#result', '(el) => el.textContent'))
    end

    reply = if result['output'].any?
      result['output'].join()
    else
      "=> #{result['evaluation']}"
    end

    status = "@#{mention.handle}\n#{reply}"

    $mastodon.post("/api/v1/statuses") do |req|
      req.headers['Idempotency-Key'] = mention_id
      req.headers['Content-Type'] = 'application/json'
      req.body = {status:, in_reply_to_id: mention_id, visibility: mention.visibility}.to_json
    end
  end
end