# frozen_string_literal: true

# Verifies the GitHub webhook signature
class GitHubSignatureValidator
  WEBHOOK_SECRET = ENV['GITHUB_WEBHOOK_SECRET'].freeze

  def self.call(request)
    new(request).call
  end

  def initialize(request)
    @request = request
  end

  def call
    valid_signature?
  end

  private

  def valid_signature?
    body, headers = prepare_request_data

    signatures_exist?(headers) && verify_all_signatures(body, headers)
  end

  def prepare_request_data
    body = @request.body.read.tap { @request.body.rewind }

    [body, extract_signature_headers]
  end

  def extract_signature_headers
    {
      sha256: @request.headers['X-Hub-Signature-256'],
      sha1: @request.headers['X-Hub-Signature']
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
end
