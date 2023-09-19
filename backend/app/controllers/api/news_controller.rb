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
    include ErrorHandler

    before_action :prepare_index_params, only: :index

    # Fetch and return the top headlines for the specified country
    # GET /api/news
    def index
      news = News::Service.call :index, @index_params

      render json: { news: }
    end

    private

    # Strong parameter handling for news
    def prepare_index_params
      @index_params = params.permit :country
    end
  end
end
