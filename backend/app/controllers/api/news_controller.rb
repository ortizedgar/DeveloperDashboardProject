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
    API_URL       = ENV.fetch 'NEWS_API_URL', 'default_url_here'
    API_KEY       = ENV.fetch 'NEWS_API_KEY', 'default_key_here'

    rescue_from Faraday::Error, with: :handle_faraday_error
    rescue_from JSON::ParserError, with: :handle_json_error

    # Fetch and return the top headlines for the specified country
    # GET /api/news
    def index
      country = news_params[:country] || 'ar'

      news = fetch_news country.to_s

      render json: { news: }
    end

    private

    # Strong parameter handling for news
    def news_params
      params.permit :country
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

    # Handles Faraday errors and responds with a 502 Bad Gateway status
    def handle_faraday_error(exception)
      render json: { error: "Failed to fetch news: #{exception.message}" }, status: :bad_gateway
    end

    # Handles JSON parsing errors and responds with a 502 Bad Gateway status
    def handle_json_error(_exception)
      render json: { error: 'Failed to parse news data' }, status: :bad_gateway
    end
  end
end
