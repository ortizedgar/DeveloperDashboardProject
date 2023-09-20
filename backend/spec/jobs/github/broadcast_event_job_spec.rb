require 'rails_helper'

RSpec.describe Github::BroadcastEventJob, type: :job do
  include ActiveJob::TestHelper

  let(:event) do
    {
      action: 'opened',
      issue: {
        title: 'New Issue'
      }
    }
  end

  describe '#perform' do
    it 'broadcasts the event to the github_events channel' do
      expect(ActionCable.server)
        .to receive(:broadcast)
        .with 'github_events', event

      Github::BroadcastEventJob.perform_now event
    end
  end
end
