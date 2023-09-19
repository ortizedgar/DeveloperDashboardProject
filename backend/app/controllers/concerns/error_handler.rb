# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
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

  def render_error(message, status)
    render json: { error: message },
           status:
  end
end
