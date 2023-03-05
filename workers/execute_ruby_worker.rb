require 'puppeteer-ruby'
require 'nokogiri'

class ExecuteRubyWorker
  include Sidekiq::Job

  def perform(mention_id)
    puts "Executing #{mention_id}"
    response = $mastodon.get("/api/v1/statuses/#{mention_id}")
    mention = Mention.new(response.body)
    result = run_code(mention.program)
    reply = Reply.new(result:, mention: mention)

    $mastodon.post("/api/v1/statuses") do |req|
      req.headers['Idempotency-Key'] = mention_id
      req.headers['Content-Type'] = 'application/json'
      req.body = reply.fields_for_api.to_json
    end
  end

  def run_code(program)
    Puppeteer.launch(headless: true) do |browser|
      page = browser.new_page
      params = { program: }
      page.goto("#{ENV['HOST_URL']}/ruby?#{params.to_param}")
      page.wait_for_selector('#result', timeout: 30_000)
      return JSON.parse(page.eval_on_selector('#result', '(el) => el.textContent'))
    end
  end
end