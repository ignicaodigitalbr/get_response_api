require 'httparty'

module GetResponseApi
  class Connection
    API_ENDPOINT = 'https://api.getresponse.com/v3'
    TIMEOUT = 7

    def initialize(api_key)
      @api_key = api_key
    end

    def post(path, body: {}, headers: {})
      headers.merge!(auth)
      HTTParty.post(
        "#{API_ENDPOINT}#{path}",
        body: body.to_json,
        headers: headers,
        timeout: TIMEOUT
      )
    end

    def get(path, body: {}, headers: {})
      headers.merge!(auth)
      HTTParty.get(
        "#{API_ENDPOINT}#{path}",
        body: body.to_json,
        headers: headers,
        timeout: TIMEOUT
      )
    end

    private

    def auth
      {
        'X-Auth-Token' => "api-key #{@api_key}",
        'Content-Type' => 'application/json'
      }
    end
  end
end
