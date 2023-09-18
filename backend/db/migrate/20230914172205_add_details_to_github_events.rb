class AddDetailsToGithubEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :github_events, :repo_name, :string
    add_reference :github_events, :user, foreign_key: true
  end
end
