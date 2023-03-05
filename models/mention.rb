class Mention
  attr_reader :mention

  def initialize(mention)
    @mention = mention
  end

  def content
    mention.fetch('content')
  end

  def visibility
    mention.fetch('visibility')
  end

  def handle
    status.dig('account', 'acct')
  end
  
  def program
    doc = Nokogiri::HTML5.fragment(content)
    doc.css('.mention,h-card').remove
    parse_program(doc.children).flatten.compact.join
  end

  private

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