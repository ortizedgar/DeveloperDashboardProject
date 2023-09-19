# frozen_string_literal: true

module GitHub
  class BroadcastEventJob < ActiveJob::Base
    # Automatically retry jobs that encountered a deadlock
    retry_on ActiveRecord::Deadlocked

    # Most jobs are safe to ignore if the underlying records are no longer available
    discard_on ActiveJob::DeserializationError

    def perform(event)
      ActionCable.server.broadcast 'github_events', event
    end
  end
end
