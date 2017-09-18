module GetResponseApi
  class Client
    def initialize(api_key)
      @connection = Connection.new(api_key)
    end

    def account
      @connection.request(:get, '/accounts')
    end

    def campaigns
      @connection.request(:get, '/campaigns')
    end

    def custom_fields
      @connection.request(:get, '/custom-fields')
    end
  end
end
