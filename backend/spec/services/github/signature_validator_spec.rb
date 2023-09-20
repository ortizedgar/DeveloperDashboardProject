# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::SignatureValidator do
  let(:webhook_secret) { 'my_secret' }
  let(:request) do
    instance_double(
      'ActionDispatch::Request',
      body: StringIO.new(payload), headers:
    )
  end
  let(:payload) { '{"key": "value"}' }
  let(:headers) do
    {
      'X-Hub-Signature-256' => sha256_signature,
      'X-Hub-Signature' => sha1_signature
    }
  end
  let(:sha256_signature) do
    "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), webhook_secret, payload)}"
  end
  let(:sha1_signature) do
    "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), webhook_secret, payload)}"
  end

  def perform
    described_class.call request
  end

  before do
    stub_const 'Github::SignatureValidator::WEBHOOK_SECRET', webhook_secret
    allow(request.headers)
      .to receive(:[])
      .with('X-Hub-Signature-256')
      .and_return sha256_signature
    allow(request.headers)
      .to receive(:[])
      .with('X-Hub-Signature')
      .and_return sha1_signature
  end

  describe '.call' do
    it 'returns true for a valid signature' do
      expect(perform)
        .to be_truthy
    end

    it 'returns false for an invalid sha256 signature' do
      allow(request.headers)
        .to receive(:[])
        .with('X-Hub-Signature-256')
        .and_return 'invalid_signature'

      expect(perform)
        .to be_falsey
    end

    it 'returns false for an invalid sha1 signature' do
      allow(request.headers)
        .to receive(:[])
        .with('X-Hub-Signature')
        .and_return 'invalid_signature'

      expect(perform)
        .to be_falsey
    end

    it 'returns true when one signature is missing but the other is valid' do
      allow(request.headers)
        .to receive(:[])
        .with('X-Hub-Signature')
        .and_return nil

      expect(perform)
        .to be_truthy
    end
  end
end
