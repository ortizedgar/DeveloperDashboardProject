# frozen_string_literal: true

class GitHubEventService
  def self.call(action, *event_params)
    new(action, event_params).call
  end

  def initialize(action, event_params)
    @action = action.to_s
    @event_params = event_params
  end

  def call
    send @action if respond_to? @action, true
  end

  private

  def index
    GithubEvent.all
  end

  def create
    event = GithubEvent.create! @event_params

    ActionCable.server.broadcast 'github_events', event
  end
end
