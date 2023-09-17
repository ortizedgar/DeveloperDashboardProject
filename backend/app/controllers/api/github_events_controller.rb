# frozen_string_literal: true

require 'openssl'

module Api
  # GithubEventsController handles incoming GitHub webhook events.
  # It verifies the GitHub webhook signature and creates a GithubEvent record.
  class GithubEventsController < ApplicationController
    WEBHOOK_SECRET = ENV['GITHUB_WEBHOOK_SECRET'].freeze

    before_action :verify_github_webhook, only: :create

    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

    # Handles incoming GitHub event
    #
    # POST /api/github_events
    def create
      GithubEvent.create! github_event_params

      render json: { message: 'Event successfully recorded' },
             status: :created
    end

    def index
      render json: { events: GithubEvent.all }
    end

    private

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

    # Verifies the GitHub webhook signature
    def verify_github_webhook
      return if valid_signature?

      render_error 'Invalid GitHub webhook signature',
                   :forbidden
    end

    def valid_signature?
      body, headers = prepare_request_data

      signatures_exist?(headers) && verify_all_signatures(body, headers)
    end

    def prepare_request_data
      body = request.body.read.tap { request.body.rewind }

      [body, extract_signature_headers]
    end

    def extract_signature_headers
      {
        sha256: request.headers['X-Hub-Signature-256'],
        sha1: request.headers['X-Hub-Signature']
      }
    end

    def signatures_exist?(headers)
      headers[:sha256].present? || headers[:sha1].present?
    end

    def verify_all_signatures(body, headers)
      verify_each_signature(body, headers[:sha256], 'sha256') &&
        verify_each_signature(body, headers[:sha1], 'sha1')
    end

    def verify_each_signature(body, their_signature, type)
      their_signature ? secure_compare_signatures(type, their_signature, body) : true
    end

    def secure_compare_signatures(type, their_signature, body)
      expected_signature = "#{type}=#{compute_signature(type, body)}"

      Rack::Utils.secure_compare expected_signature, their_signature
    end

    def compute_signature(type, body)
      OpenSSL::HMAC.hexdigest OpenSSL::Digest.new(type), WEBHOOK_SECRET, body
    end

    def github_event_params
      payload = JSON.parse(request.body.read || '').tap { request.body.rewind }

      {
        event_type: request.headers['X-GitHub-Event'],
        repo_name: payload.dig('repository', 'name'),
        payload:
      }
    end
  end
end
