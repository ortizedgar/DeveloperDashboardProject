# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubEvent, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      github_event = GithubEvent.new(
        event_type: 'push',
        payload: {
          example_key: 'example_value'
        }.to_json
      )

      expect(github_event.valid?)
        .to be_truthy
    end

    it 'is not valid without an event_type' do
      github_event = GithubEvent.new(
        payload:
          {
            example_key: 'example_value'
          }.to_json
      )

      expect(github_event.valid?)
        .to be_falsey
    end
  end
end
