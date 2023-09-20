# frozen_string_literal: true

module Github
  # EventsChannel is responsible for handling Github real-time websockets connection.
  class EventsChannel < ApplicationCable::Channel
    def subscribed
      stream_from 'github_events'
    end
  end
end
