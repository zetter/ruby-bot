require 'puppeteer-ruby'
require 'nokogiri'

class ExecuteRubyWorker
  include Sidekiq::Job

  def perform(in_reply_to_id)
    puts "Executing #{in_reply_to_id}"
    status = $mastodon.get("/api/v1/statuses/#{in_reply_to_id}").body
    content = status.fetch('content')
    visibility = status.fetch('visibility')
    handle = status.dig('account', 'acct')
    
    result = nil
    Puppeteer.launch(headless: true) do |browser|
      page = browser.new_page
      params = {
        program: program(content)
      }
      page.goto("https://ruby-bot.d2.chriszetter.com/ruby?#{params.to_param}")
      page.wait_for_selector('#result', timeout: 30_000)
      result = JSON.parse(page.eval_on_selector('#result', '(el) => el.textContent'))
    end

    reply = if result['output'].any?
      result['output'].join()
    else
      "=> #{result['output']}"
    end

    status = "@#{handle}\n#{reply}"

    $mastodon.post("/api/v1/statuses") do |req|
      req.headers['Idempotency-Key'] = in_reply_to_id
      req.headers['Content-Type'] = 'application/json'
      req.body = {status:, in_reply_to_id:, visibility:}.to_json
    end
  end

  def program(content)
    doc = Nokogiri.parse(content)
    doc.css('.mention,h-card').remove
    parse_program(doc.children).flatten.compact.join
  end

  def parse_program(nodes)
    nodes.map do |node| 
      if node.name == 'br'
        ["\n", parse_program(node.children)]
      elsif node.text?
        node.text
      elsif node.children.any?
        parse_program(node.children)
      end
    end
  end
end