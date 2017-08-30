require 'spec_helper'
require 'webmock/rspec'

RSpec.describe GetResponseApi::Client do
  let(:header) { {'Content-Type': 'application/json'} }
  let(:url)  { 'https://api.getresponse.com/v3' }
  let(:client) { described_class.new('1236547hjuh') }
  describe '#account' do
    before do
      WebMock.stub_request(:get, "#{url}/accounts")
        .to_return(body: response, headers: header)
    end

    context 'when the request is valid' do
      let(:response) { result.to_json }
      let(:result) do
        {
          "accountId"=>"pdIhh",
         "firstName"=>"Jane",
         "lastName"=>"Doe",
         "email"=>"jane.doe@test.com"
       }
      end

      subject{ client.account() }

      it { is_expected.to eq(result) }
    end

    context 'when the request is invalid' do
      let(:error_message) do
        'Unable to authenticate request. Check credentials or authentication method details'
      end
      let(:response) do
        {
          "httpStatus"=>401,
          "message"=>error_message
        }.to_json
      end

      subject{ client.account() }

      it { is_expected.to eq(error_message) }
    end
  end
end
