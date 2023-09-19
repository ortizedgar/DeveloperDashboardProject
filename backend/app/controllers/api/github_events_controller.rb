# frozen_string_literal: true

require 'openssl'

module Api
  # GithubEventsController handles incoming GitHub webhook events.
  # It verifies the GitHub webhook signature and creates a GithubEvent record.
  class GithubEventsController < ApplicationController
    before_action :verify_signature, only: :create

    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

    # Handles incoming GitHub event
    #
    # POST /api/github_events
    def create
      event = GithubEvent.create! event_params

      ActionCable.server.broadcast 'github_events', event

      render json: { message: 'Event successfully recorded' },
             status: :created
    end

    def index
      render json: { events: GithubEvent.all }
    end

    private

    def verify_signature
      return if GitHubSignatureValidator.call request

      render_error 'Invalid GitHub webhook signature',
                   :forbidden
    end

    def event_params
      payload = JSON.parse(request.body.read || '').tap { request.body.rewind }

      {
        event_type: request.headers['X-GitHub-Event'],
        repo_name: payload.dig('repository', 'name'),
        payload:
      }
    end

    # Handles ActiveRecord::RecordInvalid exceptions
    def handle_record_invalid(error)
      render_error "Failed to record event: #{error.message}",
                   :unprocessable_entity
    end

    # Handles StandardError exceptions
    def handle_standard_error(error)
      render_error "Unexpected error: #{error.message}",
                   :internal_server_error
    end

    # Renders error messages
    def render_error(message, status)
      render json: { error: message },
             status:
    end
  end
end
