# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::GithubEventsController, type: :controller do
  describe 'POST #create' do
    let(:headers) do
      {
        'X-GitHub-Event' => 'ping',
        'X-Hub-Signature-256' => 'sha256=some_signature'
      }
    end

    let(:body) { { zen: 'Keep it logically awesome.' }.to_json }

    before do
      allow(controller)
        .to receive :verify_signature

      request.headers.merge! headers
    end

    context 'when the payload is valid' do
      it 'creates a GithubEvent record' do
        expect do
          post :create, params: {}, body:, as: :json
        end.to change(GithubEvent, :count).by 1
      end

      it 'returns a status code of created' do
        post :create, params: {}, body:, as: :json

        expect(response)
          .to have_http_status :created
      end

      it 'returns a success message' do
        post :create, params: {}, body:, as: :json

        parsed_response = JSON.parse response.body

        expect(parsed_response['message'])
          .to eq 'Event successfully recorded'
      end
    end

    context 'when the payload is invalid' do
      before do
        allow(GithubEvent)
          .to receive(:create!)
          .and_raise ActiveRecord::RecordInvalid.new
      end

      it 'does not create a GithubEvent record' do
        expect do
          post :create, params: {}, body:, as: :json
        end.to_not change GithubEvent, :count
      end

      it 'returns a status code of unprocessable_entity' do
        post :create, params: {}, body:, as: :json

        expect(response)
          .to have_http_status :unprocessable_entity
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(GithubEvent)
          .to receive(:create!)
          .and_raise StandardError.new 'Something went wrong'
      end

      it 'returns a status code of internal_server_error' do
        post :create, params: {}, body:, as: :json

        expect(response)
          .to have_http_status :internal_server_error
      end
    end
  end
end
