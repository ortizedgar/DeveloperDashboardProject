# frozen_string_literal: true

module GitHub
  class EventService
    def self.call(action, params = nil)
      new(action, params).call
    end

    def initialize(action, params)
      @action = action.to_s
      @params = params
    end

    def call
      raise NotImplementedError unless respond_to? @action, true

      send @action
    end

    private

    def index
      GithubEvent.all
    end

    def create
      event = GithubEvent.create! @params

      ActionCable.server.broadcast 'github_events', event
    end
  end
end
