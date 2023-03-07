class Mention
  attr_reader :mention

  def initialize(mention)
    @mention = mention.deep_symbolize_keys
  end

  def content
    mention.fetch(:content)
  end

  def visibility
    mention.fetch(:visibility)
  end

  def handle
    mention.dig(:account, :acct)
  end

  def id
    mention.fetch(:id)
  end
  
  def program
    doc = Nokogiri::HTML5.fragment(content)
    doc.css('.mention,h-card').remove
    text = convert_entities(doc.children).flatten.compact.join
    normalize_quotes(extract_program(text)).strip
  end

  private

  def normalize_quotes(string)
    string.gsub(/[‘’]/, "'").gsub(/[“”]/, '"')
  end

  def extract_program(string)
    segments = string.split('```')
    if segments.length == 3
      segments[1]
    else
      string
    end
  end

  def convert_entities(nodes)
    nodes.map do |node| 
      if node.name == 'br'
        ["\n", convert_entities(node.children)]
      elsif node.name == 'p'
        [convert_entities(node.children), "\n"]
      elsif node.text?
        node.text
      elsif node.children.any?
        convert_entities(node.children)
      end
    end
  end  
end