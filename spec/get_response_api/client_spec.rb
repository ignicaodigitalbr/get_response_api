require 'spec_helper'
require 'webmock/rspec'

RSpec.describe GetResponseApi::Client do
  let(:header) { {'Content-Type' => 'application/json'} }
  let(:url)  { 'https://api.getresponse.com/v3' }
  let(:client) { described_class.new('1236547hjuh') }

  describe '#account' do
    before do
      WebMock.stub_request(:get, "#{url}/accounts")
             .to_return(body: response, headers: header)
    end

    context 'when the request is valid' do
      let(:result) do
        {
          'accountId' => 'pdIhh',
          'firstName' => 'Jane',
          'lastName' => 'Doe',
          'email' => 'jane.doe@test.com'
        }
      end
      let(:response) { result.to_json }

      subject { client.account }

      it { is_expected.to eq(result) }
    end

    context 'when the request is invalid' do
      let(:error_message) do
        'Unable to authenticate request. ' \
        'Check credentials or authentication method details'
      end
      let(:response) do
        {
          'httpStatus' => 401,
          'message' => error_message
        }.to_json
      end

      subject { client.account }

      it { is_expected.to eq(error_message) }
    end
  end

  describe '#campaigns' do
    before do
      WebMock.stub_request(:get, "#{url}/campaigns")
             .to_return(body: response, headers: header)
    end

    context 'when the request is valid' do
      let(:result) do
        [{
          "campaignId" => "B",
          "name" => "TestCampaigns",
          "description" => "New test campaign",
          "isDefault" => "true",
        }]
      end
      let(:response) { result.to_json }

      subject { client.campaigns }

      it { is_expected.to eq(result) }
    end

    context 'when the request is invalid' do
      let(:error_message) do
        'Unable to authenticate request. ' \
        'Check credentials or authentication method details'
      end
      let(:response) do
        {
          'httpStatus' => 401,
          'message' => error_message
        }.to_json
      end

      subject { client.campaigns }

      it { is_expected.to eq(error_message) }
    end
  end

  describe '#custom_fields' do
    before do
      WebMock.stub_request(:get, "#{url}/custom-fields")
             .to_return(body: response, headers: header)
    end

    context 'when the request is valid' do
      let(:result) do
        [{
          "customFieldId"=>"CEmpQ",
          "name"=>"age",
          "values"=>["18-29", "30-44", "45-59", "60+", "<18"]
        }]
      end
      let(:response) { result.to_json }

      subject { client.custom_fields }

      it { is_expected.to eq(result) }
    end

    context 'when the request is invalid' do
      let(:error_message) do
        'Unable to authenticate request. ' \
        'Check credentials or authentication method details'
      end
      let(:response) do
        {
          'httpStatus' => 401,
          'message' => error_message
        }.to_json
      end

      subject { client.custom_fields }

      it { is_expected.to eq(error_message) }
    end
  end
end
