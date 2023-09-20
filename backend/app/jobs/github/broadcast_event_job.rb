# frozen_string_literal: true

module Github
  # Responsible for broadcasting a GitHub event
  # to a specific ActionCable channel.
  class BroadcastEventJob < ActiveJob::Base
    retry_on ActiveRecord::Deadlocked

    discard_on ActiveJob::DeserializationError

    def perform(event)
      ActionCable.server.broadcast 'github_events', event
    end
  end
end
