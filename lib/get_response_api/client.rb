module GetResponseApi
  class Client
    def initialize(api_key)
      @connection = Connection.new(api_key)
    end

    def account
      response = @connection.get('/accounts').parsed_response

      if error?(response) && response['message']
        return response['message']
      end
      response
    end

    private

    def error?(response)
      response['httpStatus']
    end
  end
end
