# frozen_string_literal: true

module Api

  # Api::NewsController
  #
  # This controller is responsible for fetching the latest news from the News API.
  # It supports fetching headlines based on country codes.
  #
  # Example:
  #
  # GET /api/news
  # {
  #   "country": "ar"
  # }
  class NewsController < ApplicationController
    before_action :set_up_client

    HEADLINES_API = 'top-headlines'
    API_URL       = ENV.fetch('NEWS_API_URL', 'default_url_here')
    API_KEY       = ENV.fetch('NEWS_API_KEY', 'default_key_here')

    # Fetch and return the top headlines for the specified country
    # GET /api/news
    def index
      country = params.fetch(:country, 'ar').to_s # Default to 'ar' if no country specified

      begin
        news = fetch_news country
        render json: { news: }
      rescue Faraday::Error => e
        render json: { error: "Failed to fetch news: #{e.message}" }, status: :bad_gateway
      rescue JSON::ParserError
        render json: { error: 'Failed to parse news data' }, status: :bad_gateway
      end
    end

    private

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
