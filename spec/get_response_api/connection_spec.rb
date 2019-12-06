require 'spec_helper'

RSpec.describe GetResponseApi::Connection do
  let(:api_key) { 'api-key-123456' }
  let(:connection) { described_class.new(api_key) }

  describe '#request' do
    let(:url) { 'https://api.getresponse.com/v3/' }
    let(:path) { 'accounts' }
    let(:header) do
      {
        'X-Auth-Token' => "api-key #{api_key}",
        'Content-Type' => 'application/json'
      }
    end
    let(:timeout) { 7 }
    let(:response) { {} }

    describe 'when making a GET request' do
      before do
        allow(response).to receive(:parsed_response).and_return({})
        allow(HTTParty).to receive(:get).and_return(response)
        connection.get(path)
      end

      it 'should call GET with valid params' do
        expect(HTTParty).to have_received(:get)
          .with("#{url}#{path}", headers: header, timeout: timeout)
      end
    end

    describe 'when making a POST request' do
      before do
        allow(response).to receive(:parsed_response).and_return({})
        allow(HTTParty).to receive(:post).and_return(response)
        connection.post(path, {})
      end

      it 'should call POST with valid params' do
        expect(HTTParty).to have_received(:post)
          .with("#{url}#{path}", headers: header, timeout: timeout)
      end
    end

    describe 'when response is a success' do
      let(:success) { {'id' => 'ok'} }

      before do
        allow(response).to receive(:parsed_response).and_return(success)
        allow(HTTParty).to receive(:get).and_return(response)
      end

      subject { connection.get(path) }

      it 'should return success' do
        is_expected.to eq(success)
      end
    end

    describe 'when response is an error' do
      let(:error_message) { 'error' }
      let(:error) { {'httpStatus' => 404, 'message' => error_message} }

      before do
        allow(response).to receive(:parsed_response).and_return(error)
        allow(HTTParty).to receive(:get).and_return(response)
      end

      subject { connection.get(path) }

      it 'should return an error message' do
        is_expected.to eq(error_message)
      end
    end

  end
end
