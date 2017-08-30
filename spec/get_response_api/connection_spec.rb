require 'spec_helper'

RSpec.describe GetResponseApi::Connection do
  let(:apikey) { 'apikey123456' }
  let(:connection) { described_class.new(apikey) }

  describe '#post' do
    let(:url) { 'https://api.getresponse.com/v3' }
    let(:path) { '/accounts' }
    let(:body) { {} }
    let(:header) do
      {
        'X-Auth-Token' => "api-key #{apikey}",
        'Content-Type' => 'application/json'
      }
    end
    let(:timeout) { 7 }

    before do
      allow(HTTParty).to receive(:post)
      connection.post(path)
    end

    it 'should call post with valid params' do
      expect(HTTParty).to have_received(:post)
        .with("#{url}#{path}", body: body.to_json, headers: header, timeout: 7)
    end
  end

  describe '#post' do
    let(:url) { 'https://api.getresponse.com/v3' }
    let(:path) { '/accounts' }
    let(:body) { {} }
    let(:header) do
      {
        'X-Auth-Token' => "api-key #{apikey}",
        'Content-Type' => 'application/json'
      }
    end
    let(:timeout) { 7 }

    before do
      allow(HTTParty).to receive(:get)
      connection.get(path)
    end

    it 'should call post with valid params' do
      expect(HTTParty).to have_received(:get)
        .with("#{url}#{path}", body: body.to_json, headers: header, timeout: 7)
    end
  end
end
