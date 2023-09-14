# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::NewsController, type: :controller do
  let(:fake_connection) { instance_double Faraday::Connection }
  let(:fake_response) { instance_double Faraday::Response, body: '{"articles": []}', success?: true }

  before do
    allow(Faraday).to receive(:new).and_return fake_connection
    allow(fake_connection).to receive(:get).and_return fake_response
  end

  describe 'GET #index' do
    context 'when fetching news succeeds' do
      it 'returns HTTP status 200' do
        get :index

        expect(response).to have_http_status 200
      end

      it 'returns a JSON payload' do
        get :index

        json_response = JSON.parse response.body

        expect(json_response).to have_key 'news'
      end
    end

    context 'when fetching news fails due to Faraday error' do
      before do
        allow(fake_connection).to receive(:get).and_raise Faraday::Error, 'Simulated failure'
      end

      it 'returns HTTP status 502' do
        get :index

        expect(response).to have_http_status 502
      end
    end

    context 'when fetching news fails due to JSON parsing error' do
      before do
        allow(fake_response).to receive(:body).and_return 'invalid_json'
      end

      it 'returns HTTP status 502' do
        get :index
        expect(response).to have_http_status 502
      end
    end
  end
end
