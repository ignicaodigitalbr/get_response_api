require 'spec_helper'

RSpec.describe GetResponseApi::Connection do
  let(:apikey) { 'apikey123456' }
  let(:connection) { described_class.new(apikey) }

  describe '#request' do
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
    let(:response) { {} }

    describe 'when making a GET request' do
      before do
        allow(response).to receive(:parsed_response).and_return({})
        allow(HTTParty).to receive(:get).and_return(response)
        connection.request(:get, path)
      end

      it 'should call post with valid params' do
        expect(HTTParty).to have_received(:get)
          .with("#{url}#{path}", body: body.to_json, headers: header, timeout: 7)
      end
    end

    describe 'when making a POST request' do
      before do
        allow(response).to receive(:parsed_response).and_return({})
        allow(HTTParty).to receive(:post).and_return(response)
        connection.request(:post, path)
      end

      it 'should call post with valid params' do
        expect(HTTParty).to have_received(:post)
          .with("#{url}#{path}", body: body.to_json, headers: header, timeout: 7)
      end
    end

    describe 'when response is a success' do
      let(:success) { {'id' => 'all ok'} }
      before do
        allow(response).to receive(:parsed_response).and_return(success)
        allow(HTTParty).to receive(:get).and_return(response)
      end

      subject {connection.request(:get, path) }

      it 'should return success' do
        is_expected.to eq(success)
      end
    end

    describe 'when response is an error' do
      let(:error_message) { 'error_message' }
      let(:error) { {'httpStatus' => 404, 'message' => error_message} }

      before do
        allow(response).to receive(:parsed_response).and_return(error)
        allow(HTTParty).to receive(:get).and_return(response)
        connection.request(:get, path)
      end

      subject {connection.request(:get, path) }

      it 'should return error message' do
        is_expected.to eq(error_message)
      end
    end
  end
end
