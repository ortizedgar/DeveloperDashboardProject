# frozen_string_literal: true

require 'rails_helper'

RSpec.describe News::Service do
  describe '.call' do
    it 'raises NotImplementedError for unsupported actions' do
      expect { described_class.call :unsupported_action }
        .to raise_error NotImplementedError
    end
  end

  describe '#fetch_news' do
    let(:connection) { instance_double 'Faraday::Connection' }
    let(:response) do
      instance_double(
        'Faraday::Response',
        success?: true, body: '{"key": "value"}'
      )
    end

    before do
      allow(Faraday)
        .to receive(:new)
        .and_return connection
      allow(connection)
        .to receive(:get)
        .and_return response
    end

    it 'fetches news' do
      result = described_class.call :index, { country: 'us' }

      expect(result)
        .to eq 'key' => 'value'
    end

    it 'raises an error when the response is not successful' do
      allow(response)
        .to receive(:success?)
        .and_return false

      expect do
        described_class.call :index
      end.to raise_error Faraday::Error
    end
  end
end
