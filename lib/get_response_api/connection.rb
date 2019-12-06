require 'httparty'

module GetResponseApi
  class Connection

    API_ENDPOINT = 'https://api.getresponse.com/v3/'.freeze
    TIMEOUT = 7

    def initialize(api_key)
      @api_key = api_key
    end

    def get(path)
      request(:get, path)
    end

    def post(path, headers)
      request(:post, path, headers)
    end

    def delete(path)
      request(:delete, path)
    end

    def request(method, path, headers: {})
      response = http_request(method, path, headers).parsed_response

      if error?(response)
        if response['message']
          raise GetResponseError.new(response['message'])
        else
          raise GetResponseError.new('Request validation error') if response['httpStatus'].to_i == 400
          raise GetResponseError.new('Authentication error') if response['httpStatus'].to_i == 401
          raise GetResponseError.new('The throttling limit has been reached') if response['httpStatus'].to_i == 429
          raise GetResponseError.new('Unknown GetResponse v3 API error')
        end
      end

      response
    end

    private

    def http_request(request, path, headers: {})
      headers.merge!(auth)

      HTTParty.public_send(
        request,
        "#{API_ENDPOINT}#{path}",
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
      # GetResponse doesn't return an http status for successful responses (e.g. 200)
      response.is_a?(Hash) && response['httpStatus']
    end

  end
end
