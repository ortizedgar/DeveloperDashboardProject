# frozen_string_literal: true

require 'openssl'

module Api
  # Handles incoming GitHub webhook events.
  # It verifies the GitHub webhook signature and creates a GithubEvent record.
  class GithubEventsController < ApplicationController
    include ErrorHandler

    before_action :verify_signature, only: :create
    before_action :prepare_create_params, only: :create

    def create
      Github::EventService.call :create, @create_params

      render json: { message: 'Event successfully recorded' },
             status: :created
    end

    def index
      events = Github::EventService.call :index

      render json: { events: }
    end

    private

    def verify_signature
      return if Github::SignatureValidator.call request

      render json: { error: 'Invalid GitHub webhook signature' },
             status: :forbidden
    end

    def prepare_create_params
      payload = JSON.parse(request.body.read || '').tap { request.body.rewind }

      @create_params = {
        event_type: request.headers['X-GitHub-Event'],
        repo_name: payload.dig('repository', 'name'),
        payload:
      }
    end
  end
end
