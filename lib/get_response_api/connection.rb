require 'httparty'

module GetResponseApi
  class Connection

    include HTTParty

    API_ENDPOINT = 'https://api.getresponse.com/v3/'.freeze
    TIMEOUT = 7

    def initialize(api_key)
      @api_key = api_key
      setup_headers
      setup_proxy if use_proxy?
    end

    def get(path)
      url = api_url(path)

      response = self.class.get(url, :timeout => TIMEOUT).parsed_response
      handle_errors(response)

      response
    end

    def post(path, body)
      url = api_url(path)

      response = self.class.post(url, :body => body.to_json, :timeout => TIMEOUT).parsed_response
      handle_errors(response)

      response
    end

    def delete(path)
      url = api_url(path)

      response = self.class.delete(url, :timeout => TIMEOUT).parsed_response
      handle_errors(response)

      response
    end

    private

    def api_url(path)
      "#{API_ENDPOINT}#{path}"
    end

    def headers
      {
        'X-Auth-Token' => "api-key #{@api_key}",
        'Content-Type' => 'application/json',
        'Accept'       => 'application/json'
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

    def setup_proxy
      proxy_uri = URI.parse(ENV.fetch('HTTP_PROXY'))
      self.class.http_proxy(proxy_uri.host, proxy_uri.port)
    end

    def setup_headers
      self.class.headers(headers)
    end

    def use_proxy?
      !ENV.fetch('HTTP_PROXY', nil).nil?
    end

  end
end
