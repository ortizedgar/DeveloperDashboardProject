# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::EventsChannel, type: :channel do
  describe 'Subscription' do
    context 'when subscribing to the channel' do
      before do
        subscribe
      end

      it 'confirms subscription' do
        expect(subscription)
          .to be_confirmed
      end

      it 'streams from github_events' do
        expect(subscription)
          .to have_stream_from 'github_events'
      end
    end
  end
end
