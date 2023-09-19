# frozen_string_literal: true

module News
  class Service
    HEADLINES_API = 'top-headlines'
    API_URL       = ENV.fetch 'NEWS_API_URL'
    API_KEY       = ENV.fetch 'NEWS_API_KEY'

    def self.call(action, params = nil)
      new(action, params).call
    end

    def initialize(action, params)
      @action = action.to_s
      @params = params

      set_up_client
    end

    def call
      raise NotImplementedError unless respond_to? @action, true

      send @action
    end

    private

    def index
      country = @params[:country] || 'ar'

      fetch_news country.to_s
    end

    # Fetches the latest headlines for a given country
    # @param [String] country The country code
    # @return [Array<Hash>] An array of news articles
    def fetch_news(country)
      response = @connection.get do |request|
        request.url HEADLINES_API
        request.params['country'] = country
      end

      raise Faraday::Error, 'Bad response from News API' unless response.success?

      JSON.parse response.body
    end

    # Sets up the Faraday HTTP client with the necessary configurations
    def set_up_client
      @connection = Faraday.new(API_URL) do |faraday|
        faraday.headers['X-Api-Key'] = API_KEY
      end
    end
  end
end
