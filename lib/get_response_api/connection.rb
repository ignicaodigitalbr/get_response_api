require 'httparty'

module GetResponseApi
  class Connection
    API_ENDPOINT = 'https://api.getresponse.com/v3'.freeze
    TIMEOUT = 7

    def initialize(api_key)
      @api_key = api_key
    end

    def request(method, path)
      response = http_request(method, path).parsed_response

      if error?(response) && response['message']
        return response['message']
      end
      response
    end

    private

    def http_request(request, path, body: {}, headers: {})
      headers.merge!(auth)
      HTTParty.public_send(
        request,
        "#{API_ENDPOINT}#{path}",
        body: body.to_json,
        headers: headers,
        timeout: TIMEOUT
      )
    end

    def auth
      {
        'X-Auth-Token' => "api-key #{@api_key}",
        'Content-Type' => 'application/json'
      }
    end

    def error?(response)
      response.is_a?(Hash) && response['httpStatus']
    end
  end
end
