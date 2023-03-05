class Reply
  attr_reader :mention, :result

  def initialize(result:, mention:)
    @result = result.deep_symbolize_keys
    @mention = mention
  end

  def text
    "@#{mention.handle}\n#{result_text}"
  end

  def fields_for_api
    {status: text, in_reply_to_id: mention.id, visibility: mention.visibility}
  end

  private

  def result_text
    if result[:output].any?
      result[:output].join()
    else
      "=> #{result[:evaluation]}"
    end
  end
end