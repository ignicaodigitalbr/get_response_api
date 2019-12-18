require 'httparty'

module GetResponseApi
  class Connection

    API_ENDPOINT = 'https://api.getresponse.com/v3/'.freeze
    TIMEOUT = 7

    def initialize(api_key)
      @api_key = api_key
    end

    def get(path)
      url = api_url(path)

      response = HTTParty.get(url, options).parsed_response
      handle_errors(response)

      response
    end

    def post(path, body_data)
      url = api_url(path)
      post_options = { body: body_data }
      post_options.merge!(options)

      response = HTTParty.post(url, post_options).parsed_response
      handle_errors(response)

      response
    end

    def delete(path)
      url = api_url(path)

      response = HTTParty.delete(url, options).parsed_response
      handle_errors(response)

      response
    end

    private

    def api_url(path)
      "#{API_ENDPOINT}#{path}"
    end

    def options
      {
        headers: headers,
        timeout: TIMEOUT,
      }
    end

    def headers
      {
        'X-Auth-Token' => "api-key #{@api_key}",
        'Content-Type' => 'application/json',
      }
    end

    def handle_errors(response)
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
    end

    def error?(response)
      # GetResponse doesn't return an http status for successful responses (e.g. 200)
      response && response.is_a?(Hash) && response['httpStatus']
    end

  end
end
