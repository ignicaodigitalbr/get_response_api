require 'spec_helper'
require 'webmock/rspec'

RSpec.describe GetResponseApi::Client do
  let(:api_key) { '1236547hjuh' }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'X-Auth-Token' => "api-key #{api_key}",
      'Accept'       => 'application/json'
    }
  end
  let(:url)  { 'https://api.getresponse.com/v3/' }
  let(:client) { described_class.new(api_key) }

  describe '#account' do
    before do
      WebMock.stub_request(:get, "#{url}accounts")
             .to_return(body: response, headers: headers)
    end

    context 'when the request is valid' do
      let(:result) do
        {
          'accountId' => 'pdIhh',
          'firstName' => 'Jane',
          'lastName'  => 'Doe',
          'email'     => 'jane.doe@test.com'
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

      it 'raises an error' do
        expect { client.account }.to raise_error(GetResponseApi::GetResponseError)
      end
    end
  end

  describe '#campaigns' do
    before do
      WebMock.stub_request(:get, "#{url}campaigns?page=1&perPage=100")
             .to_return(body: response, headers: headers)
    end

    context 'when the request is valid' do
      let(:result) do
        [{
          'campaignId'  => 'B',
          'name'        => 'TestCampaigns',
          'description' => 'New test campaign',
          'isDefault'   => 'true',
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

      it 'raises an error' do
        expect { client.campaigns }.to raise_error(GetResponseApi::GetResponseError)
      end
    end
  end

  describe '#campaign' do
    let(:campaign_id) { 'B' }

    before do
      WebMock.stub_request(:get, "#{url}campaigns/#{campaign_id}")
             .to_return(body: response, headers: headers)
    end

    context 'when the request is valid' do
      let(:result) do
        [{
          'campaignId'  => 'B',
          'name'        => 'TestCampaigns',
          'description' => 'New test campaign',
          'isDefault'   => 'true',
        }]
      end

      let(:response) { result.to_json }

      subject { client.campaign(campaign_id) }

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

      it 'raises an error' do
        expect { client.campaign(campaign_id) }.to raise_error(GetResponseApi::GetResponseError)
      end
    end

    context 'when the campaign is invalid' do
      let(:error_message) do
        "Resource of type: campaign not found by: #{campaign_id}"
      end

      let(:response) do
        {
          'httpStatus' => 404,
          'message' => error_message
        }.to_json
      end

      it 'raises an error' do
        expect { client.campaign(campaign_id) }.to raise_error(GetResponseApi::GetResponseError)
      end
    end
  end

  describe '#custom_fields' do
    before do
      WebMock.stub_request(:get, "#{url}custom-fields")
             .to_return(body: response, headers: headers)
    end

    context 'when the request is valid' do
      let(:result) do
        [{
          'customFieldId' => 'CEmpQ',
          'name'          => 'age',
          'values'        => ['18-29', '30-44', '45-59', '60+', '<18']
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

      it 'raises an error' do
        expect { client.custom_fields }.to raise_error(GetResponseApi::GetResponseError)
      end
    end

  end
end
