# frozen_string_literal: true

module Github
  # Serves as a centralized service object for handling
  # different actions related to Github Events.
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

      Github::BroadcastEventJob.perform_later event
    end
  end
end
