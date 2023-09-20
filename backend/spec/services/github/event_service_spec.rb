require 'rails_helper'

RSpec.describe Github::EventService do
  describe '.call' do
    context 'when action is :index' do
      before do
        %w[push pull].each do |event_type|
          GithubEvent.create event_type:, payload: {}
        end
      end

      it 'returns all GithubEvent records' do
        result = described_class.call :index

        expect(result.count)
          .to eq 2
      end
    end

    context 'when action is :create' do
      let(:params) do
        {
          event_type: 'push',
          payload: {}
        }
      end

      before do
        allow(Github::BroadcastEventJob)
          .to receive :perform_later
      end

      it 'creates a new GithubEvent record' do
        expect { described_class.call :create, params }
          .to change { GithubEvent.count }
          .by 1
      end

      it 'enqueues a BroadcastEventJob' do
        described_class.call :create, params

        expect(Github::BroadcastEventJob)
          .to have_received :perform_later
      end
    end

    context 'when action is invalid' do
      it 'raises NotImplementedError' do
        expect { described_class.call :invalid_action }
          .to raise_error NotImplementedError
      end
    end
  end
end
