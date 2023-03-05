RSpec.describe Reply do
  let(:mention) { Mention.new({id: '123', visibility: 'public', account: {acct: 'test@example.com'}}) }

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
  end

  describe '#fields_for_api' do
    it 'returns the fields needed to create a status' do
      reply = described_class.new(mention:, result: {evaluation: 'hi', output: []})
      expect(reply.fields_for_api).to eq({status: "@test@example.com\n=> hi", visibility: 'public', in_reply_to_id: '123'})
    end
  end
end