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
    parse_program(doc.children).flatten.compact.join.strip
  end

  private

  def parse_program(nodes)
    nodes.map do |node| 
      if node.name == 'br'
        ["\n", parse_program(node.children)]
      elsif node.name == 'p'
        [parse_program(node.children), "\n"]
      elsif node.text?
        node.text
      elsif node.children.any?
        parse_program(node.children)
      end
    end
  end  
end