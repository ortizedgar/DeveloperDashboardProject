# frozen_string_literal: true

class GithubEventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'github_events'
  end
end
