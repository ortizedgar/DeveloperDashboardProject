# Represents a single event from GitHub.
# It contains the type of the event and the payload associated with it.
class GithubEvent < ApplicationRecord
  validates :event_type, presence: true
end

# == Schema Information
#
# Table name: github_events
#
#  id         :integer          not null, primary key
#  event_type :string
#  payload    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  repo_name  :string
#
