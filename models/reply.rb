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
    if output.any? || error
      output.concat([error || '']).join
    else
      "=> #{evaluation}"
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