# frozen_string_literal: true

require 'openssl'

module Api
  # GithubEventsController handles incoming GitHub webhook events.
  # It verifies the GitHub webhook signature and creates a GithubEvent record.
  class GithubEventsController < ApplicationController
    include ErrorHandler

    before_action :verify_signature, only: :create

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

      render json: { error: 'Invalid GitHub webhook signature' },
             status: :forbidden
    end

    def event_params
      payload = JSON.parse(request.body.read || '').tap { request.body.rewind }

      {
        event_type: request.headers['X-GitHub-Event'],
        repo_name: payload.dig('repository', 'name'),
        payload:
      }
    end
  end
end
