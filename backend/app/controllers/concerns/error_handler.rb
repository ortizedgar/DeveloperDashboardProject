# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from Faraday::Error, with: :handle_faraday_error
    rescue_from JSON::ParserError, with: :handle_json_error
  end

  private

  def handle_record_invalid(error)
    render_error "Failed to record event: #{error.message}",
                 :unprocessable_entity
  end

  def handle_standard_error(error)
    render_error "Unexpected error: #{error.message}",
                 :internal_server_error
  end

  # Handles Faraday errors and responds with a 502 Bad Gateway status
  def handle_faraday_error(exception)
    render_error "Failed to fetch news: #{exception.message}",
                 :bad_gateway
  end

  # Handles JSON parsing errors and responds with a 502 Bad Gateway status
  def handle_json_error(_exception)
    render_error 'Failed to parse news data',
                 :bad_gateway
  end

  def render_error(message, status)
    render json: { error: message },
           status:
  end
end
