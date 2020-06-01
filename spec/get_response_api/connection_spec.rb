require 'spec_helper'

RSpec.describe GetResponseApi::Connection do
  let(:api_key) { 'api-key-123456' }
  let(:url) { 'https://api.getresponse.com/v3/' }
  let(:path) { 'accounts' }
  let(:headers) do
    {
      'X-Auth-Token' => "api-key #{api_key}",
      'Content-Type' => 'application/json',
      'Accept'       => 'application/json'
    }
  end
  let(:timeout) { 7 }
  let(:response) { double }


  describe '#get' do
    context 'when making a GET request without HTTP_PROXY' do
      before do
        allow(response).to receive(:parsed_response).and_return({})
        allow(described_class).to receive(:get).and_return(response)
        described_class.new(api_key).get(path)
      end

      it 'should call GET with valid params' do
        expect(described_class).to have_received(:get)
          .with("#{url}#{path}", timeout: timeout)

        expect(described_class.headers).to eql(headers)
        expect(described_class.default_options[:http_proxyaddr]).to be_nil
        expect(described_class.default_options[:http_proxyport]).to be_nil
      end
    end

    context "when making a GET request through HTTP_PROXY when available" do
      before do
        allow(ENV).to receive(:fetch).with('HTTP_PROXY').and_return('http://1.1.1.1:123')
        allow(response).to receive(:parsed_response).and_return({})
        allow(described_class).to receive(:get).and_return(response)
        described_class.new(api_key).get(path)
      end

      it 'should call GET with valid params' do
        expect(described_class).to have_received(:get)
          .with("#{url}#{path}", timeout: timeout)

        expect(described_class.headers).to eql(headers)
        expect(described_class.default_options[:http_proxyaddr]).to eql('1.1.1.1')
        expect(described_class.default_options[:http_proxyport]).to eql(123)
      end
    end
  end

  describe '#post' do
    let(:path) { '/contacts/1' }
    let(:body) do
      { 'name': 'New Name' }
    end
    before do
      allow(response).to receive(:parsed_response).and_return({})
      allow(described_class).to receive(:post).and_return(response)
      described_class.new(api_key).post(path, body)
    end

    it 'should call POST with valid params' do
      expect(described_class).to have_received(:post)
        .with("#{url}#{path}", body: body.to_json, timeout: timeout)

      expect(described_class.headers).to eql(headers)
    end
  end

  describe '#delete' do
    let(:path) { '/contacts/1' }
    before do
      allow(response).to receive(:parsed_response).and_return({})
      allow(described_class).to receive(:delete).and_return(response)
      described_class.new(api_key).delete(path)
    end

    it 'should call DELETE with valid params' do
      expect(described_class).to have_received(:delete)
        .with("#{url}#{path}", timeout: timeout)

      expect(described_class.headers).to eql(headers)
    end
  end

  describe 'when response is a success' do
    let(:success) { {'id' => 'ok'} }

    before do
      allow(response).to receive(:parsed_response).and_return(success)
      allow(described_class).to receive(:get).and_return(response)
    end

    subject { described_class.new(api_key).get(path) }

    it 'should return success' do
      is_expected.to eq(success)
    end
  end

  describe 'when response is an error' do
    let(:error_message) { 'error' }
    let(:error) { {'httpStatus' => 404, 'message' => error_message} }

    before do
      allow(response).to receive(:parsed_response).and_return(error)
      allow(described_class).to receive(:get).and_return(response)
    end

    subject { described_class.new(api_key).get(path) }

    it 'should return an error message' do
      expect { described_class.new(api_key).get(path) }.to raise_error(GetResponseApi::GetResponseError)
    end
  end

end
