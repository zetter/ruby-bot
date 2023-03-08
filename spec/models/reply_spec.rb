RSpec.describe Reply do
  let(:mention) { Mention.new({id: '123', visibility: 'public', account: {acct: 'test@example.com'}}) }

  describe '#visibility' do
    it 'sets replies of public mentions to unlisted' do
      reply = described_class.new(mention: Mention.new({visibility: 'public'}), result: {})
      expect(reply.visibility).to eq("unlisted")
    end

    it 'uses replies of public mentions to unlisted' do
      reply = described_class.new(mention: Mention.new({visibility: 'private'}), result: {})
      expect(reply.visibility).to eq("private")
    end
  end

  describe '#text' do 
    it 'builds reply from evaulation' do
      reply = described_class.new(mention:, result: {evaluation: 'hi', output: []})
      expect(reply.text).to eq("@test@example.com\n=> hi")
    end

    it 'builds reply from output if present' do
      reply = described_class.new(mention:, result: {evaluation: 'hi', output: ["1\n", "2\n"]})
      expect(reply.text).to eq("@test@example.com\n1\n2\n")
    end

    it 'adds error after output if present' do
      reply = described_class.new(mention:, result: {evaluation: nil, error: 'error message', output: ["1\n"]})
      expect(reply.text).to eq("@test@example.com\n1\nerror message")
    end

    it 'escapes mentions produced by the program' do
      reply = described_class.new(mention:, result: {evaluation: '@spam@example.com'})
      expect(reply.text).to eq("@test@example.com\n=> ﹫spam﹫example.com")
    end

    it 'truncates the text' do
      reply = described_class.new(mention:, result: {evaluation: 'abcdefghijklmnopqrstuvwxyz'}, maximum_length: 40)
      expect(reply.text).to eq("@test@example.com\n=> abcdefgh[TRUNCATED]")
      expect(reply.text.length).to eq(40)
    end
  end

  describe '#fields_for_api' do
    it 'returns the fields needed to create a status' do
      reply = described_class.new(mention:, result: {evaluation: 'hi', output: []})
      expect(reply.fields_for_api).to eq({status: "@test@example.com\n=> hi", visibility: 'unlisted', in_reply_to_id: '123'})
    end
  end
end