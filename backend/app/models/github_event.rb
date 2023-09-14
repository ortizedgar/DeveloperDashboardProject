class GithubEvent < ApplicationRecord
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
#
