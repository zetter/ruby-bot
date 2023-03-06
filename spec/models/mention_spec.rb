RSpec.describe Mention do
  describe '#program' do
    it 'returns text from content' do
      mention = described_class.new({:content => 'text'})
      expect(mention.program).to eq('text')
    end

    it 'removes mentions' do
      content = "<p><span class=\"h-card\"><a href=\"https://mastodon.social/@rubybot\" class=\"u-url mention\" rel=\"nofollow noopener noreferrer\" target=\"_blank\">@<span>rubybot</span></a></span> 10*10</p>"
      mention = described_class.new({content: content})
      expect(mention.program).to eq('10*10')
    end

    it 'works when there are multiple root tags' do
      content = "<p><span class=\"h-card\"><a href=\"https://mastodon.social/@rubybot\" class=\"u-url mention\" rel=\"nofollow noopener noreferrer\" target=\"_blank\">@<span>rubybot</span></a></span></p><p>10*10</p>"
      mention = described_class.new({content: content})
      expect(mention.program).to eq('10*10')
    end

    it "converts br tags to new lines" do
      content = "<p><span class=\"h-card\"><a href=\"https://mastodon.social/@rubybot\" class=\"u-url mention\" rel=\"nofollow noopener noreferrer\" target=\"_blank\">@<span>rubybot</span></a></span><br>puts 'hi'<br>puts 'there'<br>23</p>"
      mention = described_class.new({content: content})
      expect(mention.program).to eq("puts 'hi'\nputs 'there'\n23")
    end

    it 'inserts new lines after paragraphs' do
      content = "<p><span class=\"h-card\"><a href=\"https://mastodon.social/@rubybot\" class=\"u-url mention\" rel=\"nofollow noopener noreferrer\" target=\"_blank\">@<span>rubybot</span></a></span></p><p>10*10</p><p>20*20</p>"
      mention = described_class.new({content: content})
      expect(mention.program).to eq("10*10\n20*20")
    end

    it 'lets you use ``` to specify the program to run' do
      content = "<p><span class=\"h-card\"><a href=\"https://mastodon.social/@rubybot\" class=\"u-url mention\" rel=\"nofollow noopener noreferrer\" target=\"_blank\">@<span>rubybot</span></a></span></p><p>not ruby</p><p>```<br>10*10</p><p>20*20<br>```</p>"
      mention = described_class.new({content: content})
      expect(mention.program).to eq("10*10\n20*20")
    end
  end
end