class Reply
  attr_reader :mention, :result, :maximum_length

  DEFAULT_MAXIMUM_LENGTH = 500
  TRUNCATION_MESSAGE = '[TRUNCATED]'

  def initialize(result:, mention:, maximum_length: DEFAULT_MAXIMUM_LENGTH)
    @maximum_length = maximum_length
    @result = result.deep_symbolize_keys
    @mention = mention
  end

  def text
    ensure_under_maximum_length("@#{mention.handle}\n#{result_text}")
  end

  def visibility
    if mention.visibility == 'public'
      'unlisted'
    else
      mention.visibility
    end
  end
  

  def fields_for_api
    {status: text, in_reply_to_id: mention.id, visibility:}
  end

  private

  def result_text
    text = if output.any? || error
      output.concat([error || '']).join
    else
      "=> #{evaluation}"
    end

    text.gsub('@', '﹫')
  end

  def ensure_under_maximum_length(string)
    if string.length > maximum_length
      truncate_to = maximum_length - TRUNCATION_MESSAGE.length
      string.slice(0, truncate_to) + TRUNCATION_MESSAGE
    else
      string
    end
  end

  def output
    result.fetch(:output, [])
  end

  def error
    result[:error]
  end

  def evaluation
    result[:evaluation]
  end
end