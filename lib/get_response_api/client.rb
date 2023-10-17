module GetResponseApi
  class Client
    def initialize(api_key)
      @connection = Connection.new(api_key)
    end

    def ping
      # checks the status of the GetResponse badge as a simple method of testing the connection
      @connection.get('accounts/badge')
    end

    def account
      @connection.get('accounts')
    end

    def campaigns(page: 1, per_page: 100)
      @connection.get("campaigns?page=#{page}&perPage=#{per_page}")
    end

    def campaign(campaign_id)
      @connection.get("campaigns/#{campaign_id}")
    end

    def contacts(page: 1, per_page: 100)
      @connection.get("contacts?page=#{page}&perPage=#{per_page}")
    end

    def create_new_contact(contact_details)
      @connection.post('contacts', contact_details)
    end

    def move_contact(contact_id, campaign_id)
      @connection.post("contacts/#{contact_id}", {'campaign' => {'campaignId': campaign_id}})
    end

    def custom_fields
      @connection.get('custom-fields')
    end
  end
end
